trigger StockChange on FeedItem (after insert) {
        
    /**
     * Feed recipes for current market close price, price up, price down
     * (1) Market Close feed: https://ifttt.com/recipes/251674-stock2salesforce
     * (2) Price Up feed: https://ifttt.com/recipes/251676-pricechange2salesforce
     * (3) Price Down feed: https://ifttt.com/recipes/251677-pricenegative2salesforce
     * If Account's TickerSymbol finds a match
     * Then it will update Stock Price Change field, which reflects Items 1, 2, and 3.
     * */
    
    List<Account> AcctList = [SELECT id, BillingCity, TickerSymbol
                              FROM Account];
    
    for (FeedItem newFeed: trigger.new){
        FeedItem thisFeed = [SELECT FeedItem.Id, FeedItem.Body 
                             FROM FeedItem 
                             WHERE Id = :newFeed.Id];


         for(integer i = 0 ; i < AcctList.size(); i++){
             if((newFeed.Body.contains('- Stock Update') 
                 || newFeed.Body.contains('Price at close'))
                && newFeed.Body.substringBetween('\'') == AcctList[i].TickerSymbol)
            AcctList[i].Stock_Price_Change__c = newFeed.Body.substringAfter('- Stock Update: ');
            update AcctList[i];
         }
    }
}
