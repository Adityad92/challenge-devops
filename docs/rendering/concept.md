# Web Rendering Strategies

## Contents

1. Client-Side Rendering (CSR)
2. Server-Side Rendering (SSR)
3. Static Site Generation (SSG)
4. Incremental Static Regeneration (ISR)

## Client-Side Rendering (CSR)
![Image title](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*yDzJ8IWjw1lp_dtI.png){ align=left }
In CSR, the server sends a bare-bones HTML document to the client. The client's browser then downloads the JavaScript and executes it to render the page content. This approach can lead to faster subsequent page loads, but the initial load might be slower.

## Server-Side Rendering (SSR)
![Image title](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*VFclAYIbLM6X7SCX.png){ align=left }
With SSR, the server generates the full HTML for a page in response to a request. This means the browser can start rendering the HTML as soon as it's received. SSR can result in a faster initial page load than CSR, but it puts more load on the server.

## Static Site Generation (SSG)
![Image title](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*pv9r5tJUQHoiD9hI.png){ align=left }
In SSG, HTML pages are generated at build time. This means the server can serve static HTML files, which can be cached and served very quickly. SSG is a good choice for sites where content doesn't change frequently.

## Incremental Static Regeneration (ISR)
![Image title](https://miro.medium.com/v2/resize:fit:1400/format:webp/0*_ZgEIfF8ucDcP_5X){ align=left }
ISR is a feature of Next.js that allows you to use static generation on a per-page basis, and regenerate pages by re-fetching data in the background as traffic comes in. This means your users get the benefits of static (always fast, always online), with the benefits of server rendering (always up-to-date).

## References

- [Understanding CSR, SSR, SSG, and ISR: A Next.js Perspective](https://bootcamp.uxdesign.cc/understanding-csr-ssr-ssg-and-isr-a-next-js-perspective-fcaf36686de6)
- https://www.youtube.com/watch?v=YkxrbxoqHDw
