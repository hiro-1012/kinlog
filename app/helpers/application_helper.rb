module ApplicationHelper
  # ゲストユーザーかどうかを判定
  def guest_user?
    current_user&.guest?
  end

  # ゲストユーザー向けの警告メッセージ
  def guest_user_warning
    if guest_user?
      content_tag(:div, class: 'alert alert-warning alert-dismissible fade show') do
        concat(content_tag(:i, '', class: 'fas fa-exclamation-triangle me-2'))
        concat('ゲストユーザーとしてログイン中です。データは保存されません。')
        concat(button_tag('×', class: 'btn-close', data: { 'bs-dismiss': 'alert' }))
      end
    end
  end

  # ゲストユーザー向けの登録促進メッセージ
  def guest_user_signup_prompt
    if guest_user?
      content_tag(:div, class: 'alert alert-info alert-dismissible fade show') do
        concat(content_tag(:i, '', class: 'fas fa-info-circle me-2'))
        concat('アプリを体験してみてください！本登録すると、データが永続的に保存されます。')
        concat(button_tag('×', class: 'btn-close', data: { 'bs-dismiss': 'alert' }))
        concat(link_to('新規登録', new_user_registration_path, class: 'btn btn-primary btn-sm ms-3'))
      end
    end
  end
end
