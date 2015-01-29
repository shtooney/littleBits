trigger IndustryFeed on FeedItem (after insert) {
    
	 /**
     * Industry News Feed recipe: https://ifttt.com/recipes/251678-industryarticle2salesforce
     * If Industry is one specified in your IFTTT feed channel = 
     * Then it will update your Industry Article and Article Link URL accordingly
     * */
    
    List<Account> AcctList = [SELECT id, BillingCity, Industry
                              FROM Account];
    
    for (FeedItem newFeed: trigger.new){
        FeedItem thisFeed = [SELECT FeedItem.Id, FeedItem.Body 
                             FROM FeedItem 
                             WHERE Id = :newFeed.Id];


         for(integer i = 0 ; i < AcctList.size(); i++){
             if(newFeed.Body.contains('via NYT') 
                && (newFeed.Body.substringAfter('- about: ').substringBefore(' via NYT') == AcctList[i].Industry))
            AcctList[i].Industry_Article__c = newFeed.Body.substringBefore('- Link: ');
			AcctList[i].Article_Link__c = newFeed.Body.substringAfter('- Link: ').substringBefore('- about: ');
            update AcctList[i];
         }
    }
}
