> With the normal attention mechanism, the runtime and memory have quadratic requirements to the input sequence length. In other words, the longer the input sequence, the exponentially higher the memory and runtime requirements.
> 
> Today, state-of-the-art models are capable of handling around 2,000 tokens, which is less than 2,000 words per input (recently an 8,192 token embedding system has been released by OpenAI).
> 
> This limits the amount of input you can provide to a model for it to understand the context and generate an output. Logically, this is not enough, as anyone that has read a book knows that context can be derived from texts that are much, much larger.
> 
> Adept.ai’s ACT-1 model leverages flash-attention, a new mechanism that they claim reduces the memory and runtime requirements to linear regarding the input sequence length.
> 
> SOURCE: https://medium.com/@ignacio.de.gregorio.noblejas/ai-more-impressive-than-chatgpt-4cc9cf343185
