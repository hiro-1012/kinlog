import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="workout-form"
export default class extends Controller {
  static targets = ["category", "exercise", "exerciseOptions", "weight", "reps", "volume"]

  connect() {
    this.recalculate()
    this.initializeSetVolumes()
  }

  filterExercises() {
    const categoryId = this.categoryTarget.value
    const optionsTemplate = this.exerciseOptionsTarget
    const select = this.exerciseTarget

    // 既存optionsを初期化
    while (select.firstChild) select.removeChild(select.firstChild)

    // 先頭にプレースホルダ
    const placeholder = document.createElement('option')
    placeholder.value = ""
    placeholder.textContent = "種目を選択"
    select.appendChild(placeholder)

    // テンプレートからカテゴリ一致のoptionのみ追加
    const options = optionsTemplate.content.querySelectorAll('option')
    options.forEach(opt => {
      if (!categoryId || opt.dataset.categoryId === categoryId) {
        select.appendChild(opt.cloneNode(true))
      }
    })
  }

  recalculate() {
    const weight = parseFloat(this.weightTarget?.value || 0) || 0
    const reps = parseInt(this.repsTarget?.value || 0) || 0
    const volume = weight * reps
    if (this.hasVolumeTarget) {
      this.volumeTarget.textContent = isFinite(volume) ? volume : 0
    }
  }

  recalculateSet(event) {
    const setRow = event.target.closest('.set-row')
    const weightInput = setRow.querySelector('.set-weight')
    const repsInput = setRow.querySelector('.set-reps')
    const volumeDisplay = setRow.querySelector('.set-volume')
    
    const weight = parseFloat(weightInput.value || 0) || 0
    const reps = parseInt(repsInput.value || 0) || 0
    const volume = weight * reps
    
    volumeDisplay.textContent = isFinite(volume) ? volume : 0
  }

  initializeSetVolumes() {
    const setRows = this.element.querySelectorAll('.set-row')
    setRows.forEach(row => {
      const weightInput = row.querySelector('.set-weight')
      const repsInput = row.querySelector('.set-reps')
      const volumeDisplay = row.querySelector('.set-volume')
      
      const weight = parseFloat(weightInput.value || 0) || 0
      const reps = parseInt(repsInput.value || 0) || 0
      const volume = weight * reps
      
      volumeDisplay.textContent = isFinite(volume) ? volume : 0
    })
  }

  addSet() {
    const container = this.element.querySelector('#sets-container')
    const setCount = container.querySelectorAll('.set-row').length
    const newIndex = setCount
    
    const newSetHTML = `
      <div class="set-row mb-3 p-3 border rounded" data-set-index="${newIndex}">
        <div class="row g-3 align-items-end">
          <div class="col-2">
            <label class="form-label fw-bold">セット${newIndex + 1}</label>
          </div>
          <div class="col-3">
            <label class="form-label">重量(kg) <small class="text-muted">任意</small></label>
            <input type="number" name="exercise_sets[${newIndex}][weight]" step="0.5" min="0" class="form-control set-weight" data-action="input->workout-form#recalculateSet">
          </div>
          <div class="col-1 text-center">
            <span class="fw-bold">×</span>
          </div>
          <div class="col-3">
            <label class="form-label">回数</label>
            <input type="number" name="exercise_sets[${newIndex}][reps]" min="0" class="form-control set-reps" data-action="input->workout-form#recalculateSet">
          </div>
          <div class="col-2">
            <div class="form-control-plaintext text-center">
              <strong class="set-volume">0</strong> kg
            </div>
          </div>
          <div class="col-1">
            <button type="button" class="btn btn-outline-danger btn-sm" data-action="click->workout-form#removeSet">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
        <div class="row mt-2">
          <div class="col-12">
            <input type="text" name="exercise_sets[${newIndex}][note]" class="form-control form-control-sm" placeholder="メモ（任意）">
          </div>
        </div>
      </div>
    `
    
    container.insertAdjacentHTML('beforeend', newSetHTML)
  }

  removeSet(event) {
    const setRow = event.target.closest('.set-row')
    setRow.remove()
    
    // セット番号を再計算
    this.updateSetNumbers()
  }

  updateSetNumbers() {
    const setRows = this.element.querySelectorAll('.set-row')
    setRows.forEach((row, index) => {
      const label = row.querySelector('.form-label.fw-bold')
      label.textContent = `セット${index + 1}`
      
      // name属性も更新
      const weightInput = row.querySelector('.set-weight')
      const repsInput = row.querySelector('.set-reps')
      const noteInput = row.querySelector('input[name*="[note]"]')
      
      weightInput.name = `exercise_sets[${index}][weight]`
      repsInput.name = `exercise_sets[${index}][reps]`
      noteInput.name = `exercise_sets[${index}][note]`
    })
  }
}
