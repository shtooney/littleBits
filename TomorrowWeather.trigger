trigger TomorrowWeather on FeedItem (after insert) {
    
    /**
     * Tomorrow's weather feed recipe: https://ifttt.com/recipes/251669-tomorrowsonsite
     * If BillingCity is one specified in your IFTTT feed channel = 
     * Then it will update your weather condition text custom field accordingly
     * */
    
    List<Account> AcctList = [SELECT id, BillingCity
                              FROM Account];
    
    for (FeedItem newFeed: trigger.new){
        FeedItem thisFeed = [SELECT FeedItem.Id, FeedItem.Body 
                             FROM FeedItem 
                             WHERE Id = :newFeed.Id];


         for(integer i = 0 ; i < AcctList.size(); i++){
             if(newFeed.Body.contains('Weather Tomorrow via Yahoo:') 
                && (newFeed.Body.substringBefore(' Weather Tomorrow via Yahoo:')
                    == AcctList[i].BillingCity))
            AcctList[i].Tomorrow_s_Weather__c = newFeed.Body.substringAfter(' Weather Tomorrow via Yahoo: ');
            update AcctList[i];
         }
    }
}
