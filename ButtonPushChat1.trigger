trigger ButtonPushChat1 on FeedItem (after insert) {

    /**
     * Recipe to feed for device: https://ifttt.com/recipes/251673-button2salesforce
     * This is for a custom object to feed device data - I called mine LittleBit__c
     * It has Message__c, Event__c, Device__c fields
     * */
    
    List<LittleBit__c> buttons = new List<LittleBit__c>();
    
    for(FeedItem f : trigger.new)
        {
            LittleBit__c littlebit = new LittleBit__c();
            
            if(f.body.contains('via littleBits'))  // criteria to define littlebits field
                littlebit.Message__c = f.Body; // Pass along the body
	            littlebit.Event__c = f.Body.substringBefore(' -'); // Define specific piece of the body to flow to a field
                littlebit.Device__c = f.Body.substringBetween('\''); // Passs along the device info
                buttons.add(littlebit);
        }

    insert buttons;
}
