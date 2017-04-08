package {
	import flash.system.Capabilities;

	public class Languages {
		private static var en:Object = {
			button_download_hq: "Download level in HD",
			button_download_lq: "Download level",
			button_download_all_hq:"Download all in HD",
			button_download_all_lq:"Download all",
			start_download:"Download started",
			button_play_lq: "Play",
			button_play_hq: "Play in HD",
			button_downloaded_all_hq: "Downloaded all in HD",
			button_downloaded_all_lq: "Downloaded all",
			button_downloading_hq: "Downloading level in HD",
			button_downloading_lq: "Downloading level",
			button_downloading_all_hq: "Downloading all in HD",
			button_downloading_all_lq: "Downloading all",
			download_error: "Download error",
			jump: "jump",
      button_restore_purchase: "Restore purchase"
		};
		private static var ru:Object = {
			button_download_hq: "Скачать уровень в HD",
			button_download_lq: "Скачать уровень",
			button_download_all_hq:"Скачать все уровни в HD",
			button_download_all_lq:"Скачать все уровни",
			start_download:"Идёт загрузка",
			button_play_lq: "Играть",
			button_play_hq: "Играть в HD",
			button_downloaded_all_hq: "Все уровни в HD скачаны",
			button_downloaded_all_lq: "Все уровни скачаны",
			button_downloading_hq: "Скачиваем уровень в HD",
			button_downloading_lq: "Скачиваем уровень",
			button_downloading_all_hq: "Скачиваем все уровни в HD",
			button_downloading_all_lq: "Скачиваем все уровни",
			download_error: "Ошибка скачивания",
			jump: "прыг",
      button_restore_purchase: "Восстановить покупку"
		};
		private static var fr:Object = {
			button_download_hq: "Télécharger le niveau en HD",
			button_download_lq: "Télécharger le niveau",
			button_download_all_hq:"Télécharger tous les niveaux en HD",
			button_download_all_lq:"Télécharger tous les niveaux",
			start_download:"Chargement en cours",
			button_play_lq: "Jouer",
			button_play_hq: "Jouer en HD",
			button_downloaded_all_hq: "Tous les niveaux en HD sont téléchargés",
			button_downloaded_all_lq: "Tous les niveaux sont téléchargés",
			button_downloading_hq: "Téléchargement du niveau en HD est en cours",
			button_downloading_lq: "Téléchargement du niveau est en cours",
			button_downloading_all_hq: "Téléchargement de tous les niveaux en HD est en cours",
			button_downloading_all_lq: "Téléchargement de tous les niveaux est en cours",
			download_error: "Erreur de téléchargement",
			jump: "saut",
      button_restore_purchase: "Restaurer achat"
		};
		private static var de:Object = {
			button_download_hq: "HD Niveau herunterladen",
			button_download_lq: "Niveau herunterladen",
			button_download_all_hq:"Alle HD Niveaus herunterladen",
			button_download_all_lq:"Alle Niveaus herunterladen",
			start_download:"Ladevorgang",
			button_play_lq: "Spielen",
			button_play_hq: "HD spielen",
			button_downloaded_all_hq: "Alle HD Niveaus sind heruntergeladen",
			button_downloaded_all_lq: "Alle Niveaus sind heruntergeladen",
			button_downloading_hq: "Laden das HD Niveau herunter",
			button_downloading_lq: "Laden das Niveau herunter",
			button_downloading_all_hq: "Laden alle HD Niveaus herunter",
			button_downloading_all_lq: "Laden alle Niveaus herunter",
			download_error: "Herunterladensfehler",
			jump: "sprung",
      button_restore_purchase: "Wiederherstellen Kauf"
		};
		private static var ja:Object = {
			button_download_hq: "HDで新レベルをダウンロード",
			button_download_lq: "新レベルをダウンロード",
			button_download_all_hq:"HDで全てのレベルをダウンロードする",
			button_download_all_lq:"全てのレベルをダウンロードする",
			start_download:"読み込み中。。。",
			button_play_lq: "プレイ",
			button_play_hq: "高解像度でゲームをプレイする",
			button_downloaded_all_hq: "全てのレベルがHDでダウンロードされた",
			button_downloaded_all_lq: "全てのレベルがダウンロードされた",
			button_downloading_hq: "HDで新レベルのダウンロード中",
			button_downloading_lq: "新レベルのダウンロード中",
			button_downloading_all_hq: "HDで全てのレベルのダウンロード中",
			button_downloading_all_lq: "全てのレベルのダウンロード中",
			download_error: "ダウンロードエラー",
			jump: "ジャンプ",
      button_restore_purchase: "購入商品を復元する"
		};
		private static var zhcn:Object = {
			button_download_hq: "下载的高清级别",
			button_download_lq: "下载级别",
			button_download_all_hq:"下载所有级别的高清",
			button_download_all_lq:"下载所有级别",
			start_download:"载入中",
			button_play_lq: "播放",
			button_play_hq: "播放高清",
			button_downloaded_all_hq: "高清下载全部水平",
			button_downloaded_all_lq: "所有下载水平",
			button_downloading_hq: "下载高清的水平",
			button_downloading_lq: "下载级别",
			button_downloading_all_hq: "下载各级HD",
			button_downloading_all_lq: "下载所有级别",
			download_error: "错误下载",
			jump: "飞跃",
      button_restore_purchase: "恢复购买"
		};

		public static var current_language:Object;

		public static function init() {
			var locale:String = Capabilities.language;

			if ( locale == "en" ) {
				current_language = en;
			}
			else if ( locale == "ru" ) {
				current_language = ru;
			}
			else if ( locale == "fr" ) {
				current_language = fr;
			}
			else if ( locale == "de" ) {
				current_language = de;
			}
			else if ( locale == "ja" ) {
				current_language = ja;
			}
			else if ( locale == "zh-CN" ) {
				current_language = zhcn;
			}
			else {
				current_language = en;
			}
		}
	}
}