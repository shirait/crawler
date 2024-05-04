require 'open-uri'
require 'nokogiri'
require 'mail'

class IosVersionCheck
  DEVICES = %w(iOS iPadOS)
  APPLE_SUPPORT_URL = 'https://support.apple.com/ja-jp/HT201222'

  def initialize; end

  def apple_support_page
    site_body = URI.open(APPLE_SUPPORT_URL).read
    Nokogiri::HTML.parse(site_body)
  end

  def os_update_info
    ret = []
    apple_support_page.css('table tr').each.with_index(1) do |node_set, i|
      # ヘッダ行はスキップする。
      next if i == 1

      # 「名前と情報リンク」、「対象」、「リリース日」の値を変数に格納する。
      version_name, _, release_date_str = node_set.css('td').map(&:text)

      # 「プレインストール」はMacOSについての記述のため不要。
      next if release_date_str == 'プレインストール'

      # リリース日が２つ書かれている場合、新しい日付を参照する。
      release_date_str = release_date_str.split(/\R/).first
      release_date = Date.new(*release_date_str.split('-').map(&:to_i))

      ret << [version_name, release_date]
    end

    ret
  end

  def latest_versions
    latest_versions = {}

    os_update_info.each do |version_name, release_date|
      DEVICES.each do |os_name|
        match_data = version_name.match(/#{os_name} (\d*)\.([\d|\.]*)/)
        next if match_data.nil?

        major_version = match_data[1] # 「X.Y.Z」の「X」の部分
        minor_version = match_data[2] # 「X.Y.Z」の「Y.Z」の部分

        latest_versions["#{os_name}_#{major_version}"] ||=
          "#{os_name} #{major_version}.#{minor_version}(#{release_date})"
      end
    end

    latest_versions
  end

  def message
    message = ['最新のiOSおよびiPadOSのバージョンとリリース日は以下になります。'] +
              latest_versions.values.sort
    message.join("\r\n")
  end

  def send_message(from_address, to_address)
    mail = Mail.new

    mail['from']      = from_address
    mail['to']        = to_address
    mail.subject      = 'iOSおよびiPadOSのバージョンお知らせメール'
    mail.body         = message
    mail.content_type = 'text/plain; charset=UTF-8'

    mail.deliver!
  end
end

# puts IosVersionCheck.new.message
# IosVersionCheck.new.send_message('送信元メールアドレス', '送信先メールアドレス')

