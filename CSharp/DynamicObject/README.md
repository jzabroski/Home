

```c#
using Castle.DynamicProxy;
using Microsoft.CSharp.RuntimeBinder;

namespace Example
{
    public class Program
    {
        public static Task Main(string[] args)
        {
            // todo: demonstrate creating a proxied object of a class with a private method,
            // and calling that private method.
            
            // then demonstrate casting the dynamic result of that private method from DynamicObject to (bool)
            // so that you can call System.Diagnostics.Debug.Assert((bool)dynamicResult);
            return Task.CompletedTask;
        }
        
        private class ExposedObject : DynamicObject
        {
            private object m_object;

            public ExposedObjectSimple(object obj)
            {
                m_object = UnwrapProxy(obj);
            }

            private static T UnwrapProxy<T>(T proxy)
            {
                if (!ProxyUtil.IsProxy(proxy))
                {
                    return proxy;
                }
                try
                {
                    const System.Reflection.BindingFlags flags = System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance;
                    var proxyType = proxy.GetType();
                    var instanceField = proxyType.GetField("__target", flags);
                    var fieldValue = instanceField.GetValue(proxy);
                    return (T)fieldValue;
                }
                catch (RuntimeBinderException)
                {
                    return proxy;
                }
            }

            public override bool TryInvokeMember(
                InvokeMemberBinder binder, object[] args, out object result)
            {
                // Find the called method using reflection
                var methodInfo = m_object.GetType().GetMethod(
                    binder.Name,
                    BindingFlags.NonPublic | BindingFlags.Public | BindingFlags.Instance);

                // Call the method
                result = methodInfo.Invoke(m_object, args);
                return true;
            }
        }
}
```
