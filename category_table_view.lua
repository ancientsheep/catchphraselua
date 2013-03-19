module(...,package.seeall);

local widget = require "widget-v1";
local json = require "json";

local listOptions = {
        top = display.statusBarHeight+24,
        height = display.contentHeight-44,
        width = 237,
        left = display.contentWidth/2,
        hideBackground = true,

        maskFile = "mask-410.png"
}

function new()

        local locTable = {};
        local list = widget.newTableView(listOptions);

        -- load our current cat lists
        local cat_list = require("categories").loadCatList();

        list.json_data = json.decode(cat_list);

        -- current word list
        list.word_list = {};

        print("list : count - "..#list.json_data);
         
        -- onEvent listener for the tableView
        local function onRowTouch(event)
                print("category_table_view : onRowTouch - "..event.phase);

                local row = event.target;
                local rowGroup = event.view;
                local itemData = json.decode(list.json_data[event.index]);

                if event.phase == "tap" or event.phase == "release" then
                        if row.isSelected==true then
                            rowGroup.alpha = 0.5;
                            row.isSelected = false;

                            -- remove this list from our word list
                            --list.word_list,event.index);
                            table.remove(list.word_list,table.indexOf(list.word_list,event.index));

                            --print current word list
                            print("Num lists in word_list: "..#list.word_list);
                            print("word_list: "..json.encode(list.word_list));

                        else 
                            rowGroup.alpha = 1.0;
                            row.isSelected = true;

                            print("Added word list .."..itemData.url_title);

                            -- add list to categories
                            --list.word_list[itemData.url_title] = {};
                            table.insert(list.word_list,event.index);

                            --print current word list
                            print("Num lists in word_list: "..#list.word_list);
                            print("word_list: "..json.encode(list.word_list));
                        end
         
                --[[elseif event.phase == "swipeLeft" then
                        if not row.isCategory then rowGroup.alpha = 1.0; end
         
                elseif event.phase == "swipeRight" then
                       if not row.isCategory then rowGroup.alpha = 1.0; end
         
                elseif event.phase == "release" then
                        row.reRender = true
                        print( "You touched row #"..event.index);
                --]]
                end
         
                return true
        end
         
        -- onRender listener for the tableView
        local function onRowRender(event)
                local row = event.target;
                local rowGroup = event.view;
                local itemData = json.decode(list.json_data[event.index]);

                print("itemData : ",itemData);
                print("render index: ",event.index);

                -- title
                local title = display.newRetinaText(itemData.title,0,0,200,25,"Soup of Justice",18)
                title:setReferencePoint( display.CenterLeftReferencePoint )
                title.x = 55;
                title.y = 15;
                title:setTextColor(255,255,255);

                -- description
                local desc = display.newRetinaText(itemData.description,0,0,180,15,"Arial",12)
                desc:setReferencePoint( display.CenterLeftReferencePoint )
                desc.x = 55;
                desc.y = 30;
                desc:setTextColor(255,255,255,100);

                -- category icon
                local icon_path = "assets/category_icons/"..itemData.icon;
                print("icon path - "..icon_path);

                local icon  = display.newImageRect(icon_path,29,30);
                icon:setReferencePoint(display.TopLeftReferencePoint);
                icon.x,icon.y = 15,5;
                
                -- must insert everything into event.view:
                rowGroup:insert(title);
                rowGroup:insert(desc);
                rowGroup:insert(icon);

                -- select all rows by default
                if row.isSelected==nil then
                    row.isSelected=true;
                end

                -- selected selected state
                if row.isSelected==true then
                    rowGroup.alpha = 1.0;
                else 
                    rowGroup.alpha = 0.5;
                end
        end
         
        -- Create 100 rows, and two categories to the tableView:
        for i=1,#list.json_data do
                local rowHeight, rowColor, lineColor, isCategory

                --add all rows by default
                table.insert(list.word_list,i);

                isCategory = false;
                rowHeight = 50;
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