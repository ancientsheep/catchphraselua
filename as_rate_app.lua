module(...,package.seeall);

local json = require("json");
 
-- settings
local numImportantEvents = 3;           -- number of important events before firing vote dialog
local dialogTitle = "Catch Phrase";
local dialogText = "Take a moment to help make Catch Phrase better by rating our app! Rate now and earn a some new card packs!";

function rateMe(params)

    print("as_rate_app : rateMe - "..json.encode(params));
    local time = preference.getValue("times");


    if(time==nil) then
        print("as_rate_app : rateMe - time=nil");
    else
        print("as_rate_app : rateMe - time="..time);
    end

    -- IF YOU RESET THE CODE UNCOMMENT THE CODE BELLOW
    --thisRate:store("time",nil);
    --thisRate:save();
    if time == nil  then
        -- FIRST TIME ENTERING YOUR APP
        print("as_rate_app : rateMe - time=nil so increment");
        time = 1;
        preference.save({times=time});
        return true;
    elseif time == (numImportantEvents+1) then
        -- THE USER DO NOT WANT TO RATE YOUR APP OR HE ALREADY MADE
        return true;
    elseif time >= 1 and time < numImportantEvents then
        print("as_rate_app : rateMe - just increment times count");
        -- IF TIME == 2 W8 FOR THE NEXT TIME
        time = time+1;
        preference.save({times=time});
        return true;
    elseif time == numImportantEvents then

        print("as_rate_app : rateMe - fire vote dialog");

        -- IF TIME == 3 CALL THE VOTE;
        local androidID,iosID;
        if params.android ~= nil then
            androidID = params.android;
        else
            androidID = "NO_ANDROID_ID";
            print("######## NO ANDROID ID");
        end
        if params.ios ~= nil then
            iosID = params.ios
        else
            iosID = "NO_IOS_ID";
            print("######## NO IOs ID");
        end
        -- MAKING THE URLS
        local AppleURL
        local AndroidURL
        AppleURL = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="..iosID;
        AndroidURL = "market://details?id="..androidID;
 
        -- EVENT NATIVE ALERT FOR IOS
        local function votariphone( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    system.openURL(AppleURL);
                    time = numImportantEvents+1;
                    preference.save({times=time});
                elseif 2 == i then                      -- restart settings (as if brand new install)
                    time = 1
                    preference.save({times=time});
                elseif 3 ==i then
                    time = numImportantEvents+1;
                    preference.save({times=time});
                end
            end
        end
        -- EVENT NATIVE ALERT FOR ANDROID
        local function votarandroid( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    system.openURL(AndroidURL);
                    time = numImportantEvents+1;
                    preference.save({times=time});
                elseif 2 == i then
                    time = 1
                    preference.save({times=time});
                elseif 3 ==i then
                    time = numImportantEvents+1;
                   preference.save({times=time});
                end
            end
        end
        local platform = system.getInfo("platformName")
 
        print("platform = "..platform);

        if platform == "iPhone OS" then
            -- THIS IS THE NATIVE ALERT FOR IPHONE
            -- YOU SHOULD CHANGE THE TEXT FOR THE WAY YOU LIKE THE MOST.
            native.showAlert(dialogTitle,dialogText,
                { "OK", "Not now", "No thanks" }, votariphone )
        
        elseif platform == "Android" then
            -- THIS IS THE NATIVE ALERT FOR ANDROID
            -- YOU SHOULD CHANGE THE TEXT FOR THE WAY YOU LIKE THE MOST.
            native.showAlert(dialogTitle,dialogText,
                { "OK", "Not now", "No thanks" }, votarandroid )
        else
            -- THIS IS FOR TEST ON YOUR PC OR MAC
            -- YOU SHOULD CHANGE THE TEXT FOR THE WAY YOU LIKE THE MOST.
            native.showAlert(dialogTitle,dialogText,
                { "OK", "Not now", "No thanks" }, votariphone )
 
        end
    end
 
 
 
end