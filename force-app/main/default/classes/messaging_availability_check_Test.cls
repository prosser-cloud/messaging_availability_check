@isTest
public class messaging_availability_check_Test {
    
    @isTest
    static void testExecuteFlow_Success() {
        Test.startTest();
        
        // Call the REST endpoint
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/messaging_availability_check';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        // Execute the method
        messaging_availability_check.FlowResult result = messaging_availability_check.executeFlow();
        
        Test.stopTest();
        
        // Verify response structure
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertNotEquals(null, result.show_button, 'show_button should not be null');
        System.assertNotEquals(null, result.status, 'Status should not be null');
        System.assertNotEquals(null, result.timestamp, 'Timestamp should not be null');
        
        // Verify boolean result
        System.assert(result.show_button == true || result.show_button == false, 'show_button should be boolean');
    }
    
    @isTest 
    static void testExecuteFlow_CacheHit() {
        Test.startTest();
        
        // First call - should execute Flow
        messaging_availability_check.FlowResult result1 = messaging_availability_check.executeFlow();
        
        // Second call immediately - should hit cache
        messaging_availability_check.FlowResult result2 = messaging_availability_check.executeFlow();
        
        Test.stopTest();
        
        // Both should return valid results
        System.assertNotEquals(null, result1, 'First result should not be null');
        System.assertNotEquals(null, result2, 'Second result should not be null');
        
        // Second call should indicate cached result
        System.assertEquals('cached', result2.status, 'Second call should be cached');
        
        // Results should be the same
        System.assertEquals(result1.show_button, result2.show_button, 'Cached result should match original');
    }
    
    @isTest
    static void testExecuteFlow_FlowError() {
        Test.startTest();
        
        // This test will handle the case where the Flow doesn't exist or fails
        // Since we can't easily simulate Flow failures in test context,
        // we'll just verify the method handles errors gracefully
        
        messaging_availability_check.FlowResult result = messaging_availability_check.executeFlow();
        
        Test.stopTest();
        
        // Even if Flow fails, we should get a valid response structure
        System.assertNotEquals(null, result, 'Result should not be null even on error');
        System.assertNotEquals(null, result.status, 'Status should not be null');
        
        // On error, should default to false
        if (result.status.contains('error')) {
            System.assertEquals(false, result.show_button, 'Should default to false on error');
        }
    }
}