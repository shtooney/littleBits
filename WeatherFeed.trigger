trigger WeatherFeed on FeedItem (after insert) {    
    
    /**
     * Today's weather feed recipe: https://ifttt.com/recipes/251668-foronsitemeetings
     * If BillingCity is one specified in your IFTTT feed channel = 
     * Then it will update your weather condition text custom field accordingly
     * */
    
    List<Account> AcctList = [SELECT id, BillingCity, Weather__c
                              FROM Account];
    
    for (FeedItem newFeed: trigger.new){
        FeedItem thisFeed = [SELECT FeedItem.Id, FeedItem.Body 
                             FROM FeedItem 
                             WHERE Id = :newFeed.Id];


         for(integer i = 0 ; i < AcctList.size(); i++){
			if((newFeed.Body.contains('Weather Today via Yahoo:'))
                && (newFeed.Body.substringBefore(' Weather Today via Yahoo:') 
                    == AcctList[i].BillingCity))
            AcctList[i].Weather__c = newFeed.Body.substringAfter(' Weather Today via Yahoo: ');
            update AcctList[i];
         }
    }
}
