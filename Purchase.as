package
{

	import com.adobe.ane.productStore.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;

	public class Purchase extends MovieClip implements IRemoveListeners
	{
		private var product_store:ProductStore;
		private const production_url:String = "https://buy.itunes.apple.com/verifyReceipt";
		private const sandbox_url:String = "https://sandbox.itunes.apple.com/verifyReceipt";
		private var try_restore:Boolean;
		private var product:Product;
		private var remove_details_listeners:Boolean = false;
		private var remove_purchase_listeners:Boolean = false;
		private var remove_finish_listeners:Boolean = false;
		private var remove_restore_listeners:Boolean = false;

		public function Purchase(_try_restore:Boolean = false)
		{
			try_restore = _try_restore;

			resize();
			addEventListener(Event.ENTER_FRAME, on_enter_frame);

			product_store = new ProductStore();

			if (ProductStore.isSupported && product_store.available)
			{
				remove_details_listeners = true;
				product_store.addEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS, productDetailsSucceeded);
				product_store.addEventListener(ProductEvent.PRODUCT_DETAILS_FAIL, productDetailsFailed);

				var vector:Vector.<String> = new Vector.<String>(1);
				vector[0] = "PiterJump";
				product_store.requestProductsDetails(vector);
			}
			else
			{
				fail();
			}
		}

		public function productDetailsSucceeded(e:ProductEvent):void
		{
			product = e.products[0] as Product;

			if (try_restore)
			{
				restore();
			}
			else
			{
				purchase();
			}
		}

		public function productDetailsFailed(e:ProductEvent):void
		{
			fail();
		}

		protected function purchaseTransactionSucceeded(e:TransactionEvent):void
		{
			var t:Transaction = e.transactions[0];
			var url:String = production_url;

			var req:URLRequest = new URLRequest(url);
			req.method = URLRequestMethod.POST;
			req.data = "{\"receipt-data\" : \"" + t.receipt + "\"}";

			var ldr:URLLoader = new URLLoader(req);
			ldr.load(req);
			ldr.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				remove_finish_listeners = true;
				product_store.addEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
				product_store.finishTransaction(t.identifier);
			});
		}

		protected function purchaseTransactionCanceled(e:TransactionEvent):void
		{
			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_LEVELSPREVIEW, true);
			dispatchEvent(ev);
		}

		protected function purchaseTransactionFailed(e:TransactionEvent):void
		{
			fail();
		}

		public function resize()
		{
			x = Data.width / 2 - width / 2;
			y = Data.height / 2 - height / 2;
			scaleX = Data.scaleX;
			scaleY = Data.scaleY;
		}

		protected function finishTransactionSucceeded(e:TransactionEvent):void
		{
			Data.purchased = true;
			Data.flush();

			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_DOWNLOAD, true);
			ev.level = 4;
			dispatchEvent(ev);
		}

		public function remove_listeners():void
		{
			removeEventListener(Event.ENTER_FRAME, on_enter_frame);

			if (remove_details_listeners)
			{
				product_store.removeEventListener(ProductEvent.PRODUCT_DETAILS_SUCCESS, productDetailsSucceeded);
				product_store.removeEventListener(ProductEvent.PRODUCT_DETAILS_FAIL, productDetailsFailed);
			}
			if (remove_purchase_listeners)
			{
				product_store.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, purchaseTransactionSucceeded);
				product_store.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL, purchaseTransactionCanceled);
				product_store.removeEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL, purchaseTransactionFailed);
			}
			if (remove_finish_listeners)
			{
				product_store.removeEventListener(TransactionEvent.FINISH_TRANSACTION_SUCCESS, finishTransactionSucceeded);
			}
			if (remove_restore_listeners)
			{
				product_store.removeEventListener(TransactionEvent.RESTORE_TRANSACTION_SUCCESS, restoreTransactionSucceeded);
				product_store.removeEventListener(TransactionEvent.RESTORE_TRANSACTION_FAIL, restoreTransactionFailed);
			}
		}

		public function on_enter_frame(e:Event)
		{
			resize();
		}

		private function fail()
		{
			var error:DownloadError = new DownloadError("", true);
			addChild(error);
			var _this:MovieClip = this;

			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent)
			{
				_this.removeChild(error);
				var ev:MenuEvent = new MenuEvent(MenuEvent.ON_LEVELSPREVIEW, true);
				dispatchEvent(ev);
			});
			timer.start();
		}

		private function purchase()
		{
			remove_purchase_listeners = true;
			product_store.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_SUCCESS, purchaseTransactionSucceeded);
			product_store.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_CANCEL, purchaseTransactionCanceled);
			product_store.addEventListener(TransactionEvent.PURCHASE_TRANSACTION_FAIL, purchaseTransactionFailed);

			product_store.makePurchaseTransaction(product.identifier, 1);
		}

		private function restore()
		{
			remove_restore_listeners = true;
			product_store.addEventListener(TransactionEvent.RESTORE_TRANSACTION_SUCCESS, restoreTransactionSucceeded);
			product_store.addEventListener(TransactionEvent.RESTORE_TRANSACTION_FAIL, restoreTransactionFailed);

			product_store.restoreTransactions();
		}

		protected function restoreTransactionSucceeded(e:TransactionEvent):void
		{
			Data.purchased = true;
			Data.flush();

			var ev:MenuEvent = new MenuEvent(MenuEvent.ON_DOWNLOAD, true);
			ev.level = 4;
			dispatchEvent(ev);
		}

		protected function restoreTransactionFailed(e:TransactionEvent):void
		{
			purchase();
		}
	}

}