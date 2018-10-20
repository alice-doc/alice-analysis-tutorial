# AliAnalysisTaskSE

Now that you are an expert at C++ classes, you might wonder why classes are relevant to writing an analysis task. In the AliPhysics analysis framework, all analysis tasks are derived from the same base class, called `AliAnalysisTaskSE`. 

{% callout "AliAnalysisTaskSE" %}
All the analysis tasks in AliPhysics are derived from the base class `AliAnalysisTaskSE`, where SE stands for 'single event'. This class in turn, is derived from the class `AliAnalysisTask` (if you are interested, you can go through the code and follow the full chain of inheritance). 

Since all analysis tasks derive from `AliAnalysisTaskSE`, all analyses share the following common, base methods:

```cpp
        AliAnalysisTaskSE::AliAnalysisTaskSE();
        AliAnalysisTaskSE::AliAnalysisTaskSE(const char*);
        AliAnalysisTaskSE::~AliAnalysisTaskSE();
        AliAnalysisTaskSE::UserCreateOutputObjects();
        AliAnalysisTaskSE::UserExec(Option_t*);
        AliAnalysisTaskSE::Terminate(Option_t*);
```

These are methods that you will always need to implement. In the following section, we will explain all these methods in detail.
{% endcallout %}
