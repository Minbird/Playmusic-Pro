PlayMP.API_KEY = "AIzaSyDVspFpFX5lq9uKg6h1hSknHIG46UDlqa0"

PlayMP.urls = {}
PlayMP.urls.ytdl = "https://minbird.kr/utils/ytdl"
PlayMP.urls.ytdl_play = PlayMP.urls.ytdl .. "/play?v="
PlayMP.urls.ytdl_download = PlayMP.urls.ytdl .. "/download/" -- 뒤에 .mp3 달아야 함
PlayMP.urls.embed = "https://www.youtube-nocookie.com/embed/"
PlayMP.urls.iframe = "https://minbird.github.io/html/app/Pro_youtube.html?uri="
PlayMP.urls.api = "https://www.googleapis.com/youtube/v3/videos"

PlayMP.selector = {}
PlayMP.selector.ytdl = [[Video]]
PlayMP.selector.embed = [[document.querySelector(".html5-video-player")]]
PlayMP.selector.iframe = [[player]]

PlayMP.openmenu = {}
PlayMP.openmenu.chat = "!playmusic"
PlayMP.openmenu.chat_short = "!pm"