window.jQuery = jQuery = require 'jquery'

# 應該是 4 ， 在 v3 API 當中， 4 代表的是 'facebook'
SOURCE = 4

# 應該是數字型字串，填入值應該為 `FACEBOOK_PAGE_ID`
note = ''

facebookPageId = 0

# 異步加載的照片們，也被預期會放在這裡面
PHOTOS_BOX = 'body'

PHOTO_BOX = '.fbPhotoCurationControlWrapper'

DEEP_PHOTO_ELEMENT = '#fbPhotoImage'

BTN_BOX = '._53d._53q'

# 功能樣版們
EXPORT_BTN = '#mypoint-export-btn'
tEXPORT_BTN = """
  <button id="mypoint-export-btn">好了，匯出！</button>
"""

EXPORT_TEXTAREA = '#mypoint-export-textarea'
tEXPORT_TEXTAREA = """
  <textarea id="mypoint-export-textarea"></textarea>
"""


# 清空已有功能樣版
jQuery("#{EXPORT_BTN}").remove()
jQuery("#{EXPORT_TEXTAREA}").remove()

# 注入功能樣版並初始化
jQuery('body').append(tEXPORT_TEXTAREA)
jQuery('body').append(tEXPORT_BTN).find("#{EXPORT_BTN}").on 'click', (event) ->
  photos = []

  # 當前臉書 粉絲團 Id
  facebookPageId = jQuery('[id^=PageHeaderPageletController_]').attr('id').match /PageHeaderPageletController_([\d]*)/
  note = facebookPageId = facebookPageId[1]

  jQuery('[mypoint-picked="true"]').each (index, DOMElement) ->
    photos.push
      image: jQuery(DOMElement).attr('mypoint-deep-img')
      note: note
      fbPageId: facebookPageId
      soruceFormatted: 'Facebook'
      source: SOURCE

  jsonString = JSON.stringify photos

  jQuery("#{EXPORT_TEXTAREA}").val(jsonString)


# 滑鼠點擊控件
jQuery("#{PHOTOS_BOX}").on 'click', "#{BTN_BOX}", (event) ->
  boxJQElement = jQuery(this).closest("#{PHOTO_BOX}")
  deepHyperJQElement = boxJQElement.find('a')

  # 沒深入過的 (expect: undefined) ，再進去深入；而有深入過的，已將 cache 記在 DOM 的 attr 上了，只要反轉選擇狀態即可。
  if not boxJQElement.attr('mypoint-picked')
    boxJQElement.attr 'mypoint-picked', yes

    boxJQElement.attr 'mypoint-pending', yes

    jQuery.get deepHyperJQElement.attr('href')
    .done (response) ->
      photoTrulySrc = jQuery(response).find("#{DEEP_PHOTO_ELEMENT}").attr('src')

      boxJQElement.attr 'mypoint-deep-img', photoTrulySrc

      boxJQElement.attr 'mypoint-pending', no

  else
    isPicked = if boxJQElement.attr('mypoint-picked') is 'true' then yes else false
    boxJQElement.attr 'mypoint-picked', !isPicked

# 本外掛所需的樣式表
jQuery('body').append jQuery('<style>').html(
  """
    /* 用自己的 button 覆蓋 FB 自己的。 */
    #{BTN_BOX} {
      background-color: rgb(157, 191, 255);
      border: 1px solid white;
      cursor: pointer;
      display: table-cell;
      height: 40px;
      text-align: center;
      vertical-align: middle;
    }

    #{BTN_BOX}::before {
      content: '選取';
      font-size: 20px;
      line-height: 37px;
      text-shadow: 1px 1px 1px black;
    }

    #{BTN_BOX}:hover {
      background-color: rgb(148, 174, 223);
    }

    #{BTN_BOX}:active {
      bottom: 2px;
    }

    /* 在這裡把 FB 自己的隱藏起來。 */
    #{BTN_BOX} > img,
    #{BTN_BOX} > div {
      display: none!important;
    }

    [mypoint-picked="true"] #{BTN_BOX} {
      background-color: rgb(73, 207, 58);
    }

    [mypoint-pending="true"] #{BTN_BOX} {
      background-color: rgb(255, 185, 179);
    }

    [mypoint-picked="true"] {
      transform: scale(0.9) rotate(-4deg) skewX(-1deg);
      box-shadow: 1px 1px 3px;
      border: 2px solid black;
    }

    #{EXPORT_BTN} {
      position: fixed;
      width: 200px;
      height: 50px;
      top: 50px;
      right: 50px;
      z-index: 1000;
      background-color: cyan;
      font-size: 20px;
    }

    #{EXPORT_TEXTAREA} {
      position: fixed;
      width: 300px;
      height: 150px;
      top: 50px;
      right: 255px;
      z-index: 1000;
      outline: 3px solid cyan;
      background-color: cyan;
      color: black;
    }
  """
)

# "src": "https://scontent-a-tpe.xx.fbcdn.net/hphotos-xfp1/v/t1.0-9/p417x417/10462540_747867158604738_7858285178975240985_n.jpg?oh=de6af82561e3f59878a7c5b3ae8015e0&oe=55615C71",
# "importSource": "4",
# "sourceNote": "527291130662343"