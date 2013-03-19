module(...,package.seeall);

local widget = require "widget-v1"
-- json
local json = require "json"

local listOptions = {
        top = 49,
        height = display.contentHeight-49,
        width = display.contentWidth,
        left = 0,
        hideBackground = true
        --maskFile = "mask-410.png"
}
 

function new(json_data)

        local locTable = {};
        local list = widget.newTableView(listOptions);

        local singleRowHeight = 50;

        locTable.data = json_data;
        locTable.currRow = -1;

        --[[
            DOWNLOAD STORY
        --]]

        local function finishedDownloading(event)
            if (event.isError) then
                    print("Network error - download failed");
                    local alert = native.showAlert("Download Error","Oops. Something went wrong while downloading pack list. Please try again.", 
                                        {"Close"},nil);
            else
                    print("success");

                    -- json decode response
                    local download_json_data = json.decode(event.response);

                    print("download_table ... write file "..download_json_data.url_title);

                    --write category file to 
                    cats = require("categories").write_category_file(download_json_data);

                    if cats == true then
                        print("Added category, remove it from list. Rebuild table?");
                        locTable.list:deleteRow(locTable.currRow);
                        table.remove(locTable.data,locTable.currRow) -- remove from json data too

                    else
                        print("Failed to add category");
                    end
            end
          
            --print("RESPONSE: "..event.response);
            native.setActivityIndicator(false);
        end

        function locTable:downloadStory()
            print("download_table : downloadStory with id: "..locTable.data[locTable.currRow].id);
            

            -- download json list
            network.request("http://www.mashmyaveragelife.com/catchphrase/download_list.php?list_id="..locTable.data[locTable.currRow].id,"GET",finishedDownloading);
        end

        --[[
            END DOWNLOAD STORY
        --]]
         
        -- do purchase
        function onPurchaseAlert(event)
            print("download_table : onPurchaseAlert - "..event.index.." currRow: "..locTable.currRow);

            -- do purchase - download story
            if event.index == 1 then
                --alert = native.showAlert("Download List","Downloading.."..table.currRow);
                locTable:downloadStory();
            end
        end


        -- onEvent listener for the tableView
        function onRowTouch(event)
                print("download_table : onRowTouch - "..event.phase);

                local row = event.target;
                local rowGroup = event.view;
         
                if event.phase == "tap" or event.phase == "release" then

                    -- Set our current row
                    locTable.currRow = event.index;

                    -- download list - it's free!
                    if(locTable.data[event.index].price == "Free") then
                        locTable:downloadStory();
                    else    --paid list
                        -- Show alert with two buttons
                        --local alert = native.showAlert("IAP Proxy","Are sure you want to buy the phrase pack: '"..locTable.data[event.index].title.."'?", 
                          --              { "Purchase", "Cancel" }, onPurchaseAlert);
                        -- show loading screen
                        native.setActivityIndicator(true);
                        --display in app purchase alert
                        as_store:doPurchase(locTable.data[event.index].bundle_id); 
                    end
                end
         
                return true
        end
         
        -- onRender listener for the tableView
        local function onRowRender(event)
                local row = event.target;
                local rowGroup = event.view;


                -- title
                local title = display.newRetinaText(locTable.data[event.index].title,0,0,200,0,"Soup of Justice",18)
                title:setReferencePoint(display.CenterLeftReferencePoint)
                title.x = 55;
                title.y = 15;
                title:setTextColor(255,255,255);

                local titleShadow = display.newRetinaText(locTable.data[event.index].title,0,0,200,0,"Soup of Justice",18)
                titleShadow:setReferencePoint(display.CenterLeftReferencePoint)
                titleShadow.x = 55+1;
                titleShadow.y = 15+1;
                titleShadow:setTextColor(0,0,0);

                -- description
                local desc = display.newRetinaText(locTable.data[event.index].description,0,0,display.contentWidth-55-80,0,"Arial",12)
                desc:setReferencePoint(display.CenterLeftReferencePoint)
                desc.x = 55;
                desc.y = 32;
                desc:setTextColor(255,255,255,100);

                local free_bk = "";

                -- price
                local pricer = locTable.data[event.index].price;
                if(pricer~= "Free") then
                    pricer = "$"..pricer;
                else
                    free_bk = "_free";
                end

                local price = display.newRetinaText(pricer,0,0,180,0,"Arial Bold",12)
                price:setReferencePoint(display.CenterReferencePoint);
                price.x = display.contentWidth-50;
                price.y = singleRowHeight/2-2;
                price:setTextColor(255,255,255,255);

                -- price shadow
                local priceShadow = display.newRetinaText(pricer,0,0,180,0,"Arial Bold",12)
                priceShadow:setReferencePoint(display.CenterReferencePoint);
                priceShadow.x = display.contentWidth-49;
                priceShadow.y = singleRowHeight/2+1-2;
                priceShadow:setTextColor(0,0,0,200);

                -- category icon
                local icon_path = "assets/category_icons/"..locTable.data[event.index].icon;
                print("icon path - "..icon_path);

                local icon  = display.newImageRect(icon_path,29,30);
                icon:setReferencePoint(display.CenterReferencePoint);
                icon.x,icon.y = 27,singleRowHeight/2-1;

                local buyIcon = display.newImageRect("assets/downloads/buy_bk"..free_bk..".png",46,47);
                buyIcon:setReferencePoint(display.TopLeftReferencePoint);
                buyIcon.x,buyIcon.y = display.contentWidth - 72,1;

                -- must insert everything into event.view:
                rowGroup:insert(titleShadow);
                rowGroup:insert(title);
                rowGroup:insert(desc);
                rowGroup:insert(icon); 
                rowGroup:insert(buyIcon);
                rowGroup:insert(priceShadow);
                rowGroup:insert(price);   
        end
         
        -- Create 100 rows, and two categories to the tableView:
        for i=1,#locTable.data do
                local rowHeight, rowColor, lineColor, isCategory
                local item_data = locTable.data[i];

                print("JSON: "..item_data.title);

                isCategory = false;
                rowHeight = singleRowHeight;
                rowColor={ 20, 20, 20, 0};
                lineColor={255,255,255,20};            
                -- function below is responsible for creating the row
                list:insertRow{
                        onEvent=onRowTouch,
                        onRender=onRowRender,
                        height=rowHeight,
                        isCategory=isCategory,
                        rowColor=rowColor,
                        lineColor=lineColor,
                        isSelected=true,
                }
        end

        locTable.list = list;

        return locTable;
end