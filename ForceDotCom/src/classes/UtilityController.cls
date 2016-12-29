public class UtilityController {
	//Create a map of all RecordType Name to Ids based upon a passed object
    public static Map<String,Id> buildMapOfRecordTypes(String passedSobjectType) {
		Map<String,Id> returnMap = new Map<String,Id>(); //the return map variable
		for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType = :passedSobjectType]) { 
			returnMap.put(rt.Name, rt.Id); 
		}
		return returnMap;
	}
}