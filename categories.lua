module(...,package.seeall);

local json = require "json";

-- load individual file for specific category

function loadCategory(fileName)

	print("loadCategory: "..fileName);
	local path = system.pathForFile(fileName..".txt",system.DocumentsDirectory);

	print("path: "..path);

	local file = io.open(path,"r");

	if file==nil then
	    io.output("ERROR :: Could not read file..");
	    io.close();
	else
		cat = file:read("*a");
		file:close();

		print("categories : loadCategory SUCCESS ");
		return json.decode(cat);
	end
end

-- return new json data from remote feed, removing any lists that currently exist

function compareLocalToRemoteList(json_data)
	print("compareLocalToRemoteList : "..json.encode(json_data));

	local remote_data = json_data;
	local local_list = json.decode(loadCatList());		-- load local category list
	local new_list = {};

	for i=1,#remote_data do
		local remote_item = remote_data[i];
		print("comparing remote url_title "..remote_item.url_title.." to local");
		if catDoesExistInList(local_list,remote_item.url_title)==false then
			new_list[#new_list+1] = remote_item;
		end
	end

	return new_list;
end

function catDoesExistInList(list,url_title)
	print("catDoesExistInList : "..url_title);

	for i=1,#list do
		local item = json.decode(list[i]);
		print(" .. comparing "..item.url_title.." to "..url_title);

		if item.url_title == url_title then
			print("LIST EXISTS")
			return true;
		end
	end

	print("LIST DOES NOT EXIST");

	return false;
end


function copyCategoriesAndListFromResources()
	print("copyCategoriesAndListFromResources");

	-- copy category list from resources
	local copyGood = copyFile("assets/categories/category_list.txt",system.ResourceDirectory,"category_list.txt",system.DocumentsDirectory,false);
	local catList = loadCatList();
	catList = json.decode(catList);

	-- parse our cat list and copy each file over
	print("num inside cat list : "..#catList);

	-- copy individual lists over
	for i=1,#catList do
		print("copying over individual list from resources .."..catList[i]);
		local item = json.decode(catList[i]);
		local copied = copyFile("assets/categories/"..item.url_title..".txt",system.ResourceDirectory,item.url_title..".txt",system.DocumentsDirectory,false);
	end
end

-- Load the current categories list
function loadCatList()

	local path = system.pathForFile("category_list.txt",system.DocumentsDirectory);

	print("path: "..path);

	local file = io.open(path,"r");

	if file==nil then
	 
	    io.close();
		copyCategoriesAndListFromResources();

	    -- try to read again
	    return loadCatList();
	else
		cat = file:read("*a");
		file:close();

		print("categories : loadCatList SUCCESS "..cat);
		return cat;
	end
end

-- Load the current categories list
function writeCatList(json_data)

	local path = system.pathForFile("category_list.txt",system.DocumentsDirectory);

	print("path: "..path);

	local file = io.open(path,"w");

	if file==nil then
	    io.output("ERROR :: Could not read file..");
	    io.close();

	    -- copy list from resources
	    copyCategoriesAndListFromResources();

	    -- try to read again
	    return writeCatList(json_data);
	else
		file:write(json.encode(json_data));
		file:close();

		print("categories : writeCatList SUCCESS ");
		return true;
	end
end

-- add to cat list to cat list file
function addCategoryToCatList(json_data)
	print("categories : addCategoryToCatList");

	-- load cat list
	local catList = loadCatList();

	print("categories : addCategoryToCatList : loaded catList "..catList);

	catList = json.decode(catList);

	local new_json = {};
	new_json.id = json_data.id;
	new_json.title = json_data.title;
	new_json.url_title = json_data.url_title;
	new_json.description = json_data.description;
	new_json.icon = json_data.icon;

	print("Category icon: "..json_data.icon);

	catList[#catList+1] = json.encode(new_json);

	return writeCatList(catList);
end


-- categories + words for each

function loadAll()
	categories = {};
	categories.word_list = {};
	categories.word_list_unused = {};

	loadCatList();

	function categories:copy()

		for i = 1, #categories.word_list do
			categories.word_list_unused[i] = categories.word_list[i];
		end
	end

	function categories:randomWord()

		if(#categories.word_list_unused == 0) then
			categories:copy();
		end

		local rand = math.random(1,#global_categories.word_list_unused);
		local word = categories.word_list_unused[rand];
		table.remove(categories.word_list_unused, rand);

		print("unsed words length = "..#categories.word_list_unused);

		return word;
	end

	return categories;
end

-- copy over category_list.txt to user docs if it doesn't exist
function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
    local results = true                -- assume no errors
 
    -- Copy the source file to the destination file
    --
    local rfilePath = system.pathForFile( srcName, srcPath )
    local wfilePath = system.pathForFile( dstName, dstPath )
 
    local rfh = io.open(rfilePath,"rb")              
    local wfh = io.open(wfilePath,"wb")
        
    if  not wfh then
        print( "writeFileName open error!" )
        results = false                 -- error
    else
        -- Read the file from the Resource directory and write it to the destination directory
        local data = rfh:read( "*a" )
                
        if not data then
            print( "read error!" )
            results = false     -- error
        else
            if not wfh:write( data ) then
                print( "write error!" ) 
                results = false -- error
            end
        end
    end
        
        -- Clean up our file handles
        rfh:close()
        wfh:close()
 
        return results  
end

function write_category_file(json_data)
	print("categories : write_category_file "..json_data.url_title);

	local path = system.pathForFile(json_data.url_title..".txt",system.DocumentsDirectory);
	local file = io.open(path,"w");

	if file==nil then
	    io.output("ERROR :: Could not write file.."..path);
	    io.close()
	end

	file:write(json.encode(json_data));
	file:close();

	print("categories : write_category_file SUCCESS");

	return addCategoryToCatList(json_data);
end

--[[function testDB()
	print("--- JSON TEST DATABASE ----");
	print("RIPPING THAT FUCKERS WORD DB!! MUAHAHAAHAHHAH");

	-- Copy the source file to the destination file
    --
    local rfilePath = system.pathForFile("assets/database.json",system.ResourceDirectory);
    local rfh = io.open(rfilePath,"rb");
    local wfilePath = system.pathForFile("new_db.txt", system.DocumentsDirectory )              
    local wfh = io.open(wfilePath,"w");

    -- Read the file from the Resource directory and write it to the destination directory
    local data = rfh:read("*a");
            
    if not data then
        print( "read error!" )
    else
         print("data - "..data);

         -- decode data
         local decoded = json.decode(data);
         local lastCategory = "";
         --decoded = decoded.words

         print("decoded words count - "..#decoded.words);
         --iterate through all words
         for i=1,#decoded.words do
         	local item = decoded.words[i];
         	local currCat = item.category;
         	local words = item.word;

         	-- same as prev category
         	-- just print the word
         	if(lastCategory == currCat) then
         		print(words);

         		wfh:write(words.."\n");

         	else
         		lastCategory = currCat;
         		print("Category: "..currCat);

         		print(words);
         		wfh:write("Category: "..currCat.."\n");
         		wfh:write(words.."\n");
         	end


         end

    end
    
    -- Clean up our file handles
    rfh:close()
end--]]
