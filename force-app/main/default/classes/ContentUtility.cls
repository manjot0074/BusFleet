public with sharing class ContentUtility {

    // This method returns map of contenturls related to given records
    public static Map<Id,List<String>> getParentIdContentUrlMap(Set<Id> parentId){
        Map<Id,List<String>> parentIdContentUrlMap = new Map<Id,List<String>>();
        Map<Id,Id> contentDocumentParentMap = new Map<Id,Id>();
        if(parentId.isEmpty()){
            return parentIdContentUrlMap;
        }
        List<ContentDocumentLink> documentLinks = [select LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId IN :parentId WITH SECURITY_ENFORCED];
        for(ContentDocumentLink link : documentLinks){
            contentDocumentParentMap.put(link.ContentDocumentId, link.LinkedEntityId);
        }
        List<Id> documentIds = new List<Id>(contentDocumentParentMap.keyset());
        List<ContentVersion> versions = [select id,ContentUrl,PathOnClient,ContentDocumentId from ContentVersion where ContentDocumentId in :documentIds and isLatest=true WITH SECURITY_ENFORCED];
        for(ContentVersion ver : versions){
            List<String> contentUrls = new List<String>();
            if(parentIdContentUrlMap.get(contentDocumentParentMap.get(ver.ContentDocumentId)) != null){
                contentUrls = parentIdContentUrlMap.get(contentDocumentParentMap.get(ver.ContentDocumentId));
            }
            system.debug(ver.Id);
            contentUrls.add(ver.Id);
            parentIdContentUrlMap.put(contentDocumentParentMap.get(ver.ContentDocumentId),contentUrls);
            system.debug(parentIdContentUrlMap);
        }
        return parentIdContentUrlMap;
    }
}