// Set visualizer
var template = `{{{response.body}}}`;

pm.visualizer.set(template, {
    // Pass the response body parsed as JSON as `data`
    response: pm.response.json()
});