trigger FeedJob on FeedItem (after insert) {

	 /**
     * LinkedIn Jobs recipe: https://ifttt.com/recipes/251679-rss2salesforce
     * If company Name matches company name of job posted on LinkedIn (must follow company on LinkedIn)
     * Then it will update your Job Info on company accordingly
     * */
    
    List<Account> AcctList = [SELECT id, BillingCity, Name
                              FROM Account];
    
    for (FeedItem newFeed: trigger.new){
        FeedItem thisFeed = [SELECT FeedItem.Id, FeedItem.Body
                             FROM FeedItem 
                             WHERE Id = :newFeed.Id];

         for(integer i = 0 ; i < AcctList.size(); i++){
             if(newFeed.Body.contains('Job Detail per LinkedIn: ') 
                && newFeed.Body.contains(AcctList[i].Name))
            AcctList[i].Job__c = newFeed.Body;
			update AcctList[i];
         }
    }
}
