global class LS_ChatterCreatePost {
    
    global class ChatterPostWrapper{
        @InvocableVariable(required=true)
        global String leadId;
        @InvocableVariable(required=true)
        global String chatterGroupId;
    }
    
    @InvocableMethod    
    global static void postFeed(ChatterPostWrapper[] wrappers){
        if(wrappers != null){
            for(ChatterPostWrapper wrapper : wrappers){
                Lead lead = [
                    SELECT Id, FirstName, LastName, CreatedById, CreatedBy.Name
                    FROM Lead
                    WHERE Id = :wrapper.leadId
                ];
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                feedItemInput.body = new ConnectApi.MessageBodyInput();
                feedItemInput.subjectId = wrapper.chatterGroupId;
                feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                ConnectApi.EntityLinkSegmentInput accountLinkLink = new ConnectApi.EntityLinkSegmentInput();
                accountLinkLink.entityId = lead.CreatedById;
                feedItemInput.body.messageSegments.add(accountLinkLink);
                ConnectApi.TextSegmentInput message = new ConnectApi.TextSegmentInput();
                message.text = ' has created a new lead ';     
                feedItemInput.body.messageSegments.add(message);
                ConnectApi.EntityLinkSegmentInput leadLink = new ConnectApi.EntityLinkSegmentInput();
                leadLink.entityId = lead.Id;
                feedItemInput.body.messageSegments.add(leadLink);
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            }
        }
    }
}