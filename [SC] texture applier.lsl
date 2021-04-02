/*Parameter*/
integer face = ALL_SIDES;
integer link = LINK_THIS;
list textureLabel=["texture1","texture2","texture3"];
list textureUuid=["15ec95e5-1bba-aac4-debe-dc8fe9c1a21a","30c2fa67-9699-b0e8-7c91-6213dcde5f18","b168319c-d6e6-90be-2bce-ec8dc272ee7a"];
list whitelist=["liviaolovely"]; 

string cur;
integer menu_handler;
integer menu_channel;

menu(key user,string title,list buttons) 
{
    menu_channel = (integer)llFrand(-999999.0);
    menu_handler = llListen(menu_channel,"",user,"");
    llDialog(user,title,buttons,menu_channel);
    llSetTimerEvent(60);
}

default
{
    state_entry()
    {
      cur ="none";
    }
    
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }
    
    on_rez(integer start_param)
    {
         llResetScript();
    }

    touch_start(integer total_number)
    {
        string name =  llGetUsername(llDetectedKey(0));
        key toucher=llDetectedKey(0);
        if(toucher==llGetOwner()||~llListFindList(whitelist,(list)name))
        {
           menu(toucher,"Select texture\ncurrent texture:"+cur,textureLabel);
        }
        else
        { 
            llInstantMessage(toucher,"You don't have access");
        }
    }
    
    listen( integer channel, string name, key id, string message )
    {
        integer index = llListFindList(textureLabel,[message]);
        if(~index)
        {
         string txt = llList2String(textureUuid,index);
         cur = message;
         llSetLinkPrimitiveParamsFast(link, [PRIM_TEXTURE, face, txt,<1.0,1.0,1.0>,<0.0,0.0,0.0>, 0.0]);
         llSetTimerEvent(0.0);
         llListenRemove(menu_handler);
        }
    }
    
    timer() 
    {
        llSetTimerEvent(0.0);
        llListenRemove(menu_handler);    
    }
}
