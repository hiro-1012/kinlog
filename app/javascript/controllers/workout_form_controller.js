import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="workout-form"
export default class extends Controller {
  static targets = ["category", "exercise", "exerciseOptions", "weight", "reps", "volume"]

  connect() {
    this.recalculate()
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
}
