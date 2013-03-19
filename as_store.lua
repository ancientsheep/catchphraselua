module(...,package.seeall);

local store = require("store")

function init()
        local asstore = {};

        print("as_store : init");
        -- call back function for store
        function transactionCallback(event)

                native.setActivityIndicator(false);

                if(event==nil) then
                        native.showAlert("IAP","Transaction event is nil. "..#event, 
                                        {"Close"},nil);
                        return;
                end



                local transaction = event.transaction;

                
                
                native.showAlert("IAP","Transaction returned something!!", 
                                        {"Close"},nil);

                if transaction.state == "purchased" then
                        print("Transaction succuessful!")

                        native.showAlert("IAP","Transaction successful!", 
                                        {"Close"},nil);
         
                elseif  transaction.state == "restored" then
                        print("Transaction restored (from previous session)")
                        print("productIdentifier", transaction.productIdentifier)
                        print("receipt", transaction.receipt)
                        print("transactionIdentifier", transaction.identifier)
                        print("date", transaction.date)
                        print("originalReceipt", transaction.originalReceipt)
                        print("originalTransactionIdentifier", transaction.originalIdentifier)
                        print("originalDate", transaction.originalDate)

                        native.showAlert("IAP","Transaction restored!", 
                                        {"Close"},nil);
         
                elseif transaction.state == "cancelled" then
                        print("User cancelled transaction")
                        native.showAlert("IAP","Transaction cancelled!", 
                                        {"Close"},nil);
         
                elseif transaction.state == "failed" then
                        print("Transaction failed, type:", transaction.errorType, transaction.errorString)

                        native.showAlert("IAP","Transaction FAILED! Err code: "..transaction.errorType..transaction.errorString, 
                                        {"Close"},nil);
         
                else
                        print("Unknown event");

                        native.showAlert("IAP","Unknown event", 
                                        {"Close"},nil);
                end
         
                -- Once we are done with a transaction, call this to tell the store
                -- we are done with the transaction.
                -- If you are providing downloadable content, wait to call this until
                -- after the download completes.
                store.finishTransaction(transaction);
        end

        function asstore:checkCanPurchase(shouldShowDialog)
                if(store.canMakePurchases==true) then
                        return true;
                else
                        if shouldShowDialog == true then
                                native.showAlert("Uh oh","This device cannot currently make purchases. Please check your settings and try again.",
                                        {"Close"},nil);
                        end
                end
        end

        function asstore:restorePurchases()
                store.restore();
        end

        function loadProductsCallback( event )
                print("showing products", #event.products)
                for i=1, #event.products do
                        local currentItem = event.products[i];

                        native.showAlert("IAP","Found product..."..currentItem.productIdentifier,
                                        {"Close"},nil);

                        print(currentItem.title)
                        print(currentItem.description)
                        print(currentItem.price)
                        print(currentItem.productIdentifier)
                end
                print("showing invalidProducts", #event.invalidProducts)
                for i=1, #event.invalidProducts do
                        native.showAlert("IAP","Invalid product found..."..event.invalidProducts[i],
                                        {"Close"},nil);
                end
        end

        function asstore:getProductInfo()
                arrayOfProductIdentifiers = 
                {
                        "com.ancientsheep.catchphrasefree.movies"
                }
                store.loadProducts( arrayOfProductIdentifiers, loadProductsCallback )
        end

        -- do purchase for specific bundle id
        function asstore:doPurchase(bundleID)
                local purchases = {"com.ancientsheep.catchphrasefree.movies"};
                --purchases[1] = bundleID;

                native.showAlert("IAP","Doing purchase for..."..purchases[1],
                                        {"Close"},nil);

                store.purchase(purchases);

                

                --native.setActivityIndicator(true);
        end


        store.init(transactionCallback);
        asstore:getProductInfo();


        return asstore;
end