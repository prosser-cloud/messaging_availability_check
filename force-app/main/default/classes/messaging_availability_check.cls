@RestResource(urlMapping='/messaging_availability_check')
global without sharing class messaging_availability_check {
    
    // Simple caching to reduce Flow executions
    private static Boolean cachedResult;
    private static DateTime cacheExpiry;
    private static final Integer CACHE_MINUTES = 5;
    
    @HttpGet
    global static FlowResult executeFlow() {
        try {
            System.debug('REST API: Flow execution requested at ' + DateTime.now());
            
            // Check cache first
            if (cachedResult != null && cacheExpiry != null && DateTime.now() < cacheExpiry) {
                System.debug('REST API: Returning cached result: ' + cachedResult);
                return new FlowResult(cachedResult, 'cached');
            }
            
            // Execute fresh Flow
            System.debug('REST API: Executing fresh Flow');
            Flow.Interview.Messaging_Button_Availability flowInterview = 
                new Flow.Interview.Messaging_Button_Availability(new Map<String, Object>());
            flowInterview.start();
            
            Boolean showButton = (Boolean) flowInterview.getVariableValue('show_button');
            System.debug('REST API: Flow returned show_button: ' + showButton);
            
            // Cache the result
            cachedResult = showButton != null ? showButton : false;
            cacheExpiry = DateTime.now().addMinutes(CACHE_MINUTES);
            
            return new FlowResult(cachedResult, 'fresh');
            
        } catch (Exception e) {
            System.debug('REST API Error: ' + e.getMessage());
            return new FlowResult(false, 'error: ' + e.getMessage());
        }
    }
    
    // Response wrapper
    global class FlowResult {
        global Boolean show_button;
        global String status;
        global DateTime timestamp;
        
        global FlowResult(Boolean showButton, String status) {
            this.show_button = showButton;
            this.status = status;
            this.timestamp = DateTime.now();
        }
    }
}