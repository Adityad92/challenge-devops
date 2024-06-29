CSP stands for Content Security Policy, which is a security standard introduced to help prevent cross-site scripting (XSS), clickjacking, and other code injection attacks resulting from the execution of malicious content in the trusted web page context. CSP is implemented by specifying a policy (a set of directives) that defines which dynamic resources are allowed to load and execute in the browser, such as scripts, stylesheets, images, fonts, and more.  
   
When you set a CSP for your website, you're essentially creating a whitelist of sources of trusted content. The browser will enforce this policy and only execute or render resources from the specified sources, blocking any other potentially malicious scripts or resources.  
   
Here's a basic example of what a CSP header might look like:  
   
```  
Content-Security-Policy: default-src 'self'; script-src 'self' https://apis.example.com; img-src 'self' https://images.example.com;  
```  
   
In this policy:  
   
- `default-src 'self'` restricts all content sources to the same origin as the document itself unless otherwise specified by another directive.  
- `script-src 'self' https://apis.example.com` allows script execution from the same origin and from `https://apis.example.com`.  
- `img-src 'self' https://images.example.com` allows loading images from the same origin and from `https://images.example.com`.  
   
Without diagrams, it's a bit challenging to depict the flow, but here's a textual representation:  
   
1. A user visits your website.  
2. The browser requests the page and receives the HTML along with the CSP header.  
3. As the browser parses the HTML and encounters resources such as scripts, images, etc., it checks the CSP.  
4. If a resource's source is not listed in the CSP, the browser blocks that resource from loading or executing.  
5. If the resource's source is allowed by the CSP, the browser proceeds to load and execute it.  
   
Without CSP:  
- If your website doesn't have a CSP or has a very permissive one (like `default-src *;` which allows any source), it can easily become a victim of XSS and other attacks.  
- An attacker could exploit a vulnerability in your website to inject malicious scripts.  
- When users visit your website, their browsers could execute these malicious scripts, leading to stolen data, defaced websites, or other security issues.  
   
With CSP:  
- With a strict CSP in place, even if an attacker manages to inject a script or link a malicious resource, the browser will not load or execute it if the source is not in the whitelist.  
- This significantly reduces the risk of XSS and other attacks, protecting both your website and your users.  
   
Remember, CSP is not a silver bullet and should be part of a defense-in-depth strategy. It's vital to keep your application secure by following best practices in coding, keeping software up-to-date, and conducting regular security reviews.