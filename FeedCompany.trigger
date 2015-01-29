trigger FeedCompany on FeedItem (after insert) {
    
	 /**
     * Company News Feed recipe: https://ifttt.com/recipes/251679-rss2salesforce
     * If company Name is one specified in your IFTTT feed channel = 
     * Then it will update your Company Headline accordingly (and URL)
     * */
    
    List<Account> AcctList = [SELECT id, BillingCity, Name
                              FROM Account];
    
    for (FeedItem newFeed: trigger.new){
        FeedItem thisFeed = [SELECT FeedItem.Id, FeedItem.Body
                             FROM FeedItem 
                             WHERE Id = :newFeed.Id];

         for(integer i = 0 ; i < AcctList.size(); i++){
             if(newFeed.Body.contains('Feed via RSS -') 
                && (newFeed.Body.substringBefore(' Feed via RSS -').contains(AcctList[i].Name)))
            AcctList[i].Headline__c = newFeed.Body.substringAfter('Feed via RSS -');
			//AcctList[i].Headline_Link__c = newFeed.Body.substringAfter('- RSS Info: ') //If you want to pass URL info separately like you did with Industry feed trigger
			update AcctList[i];
         }
    }
}
