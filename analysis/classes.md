# Introduction - AliAnalysisTaskSE

All the code that you will find in ROOT, AliRoot and AliPhysics is written in the form of C++ *classes*. A class is **put definiiton here** . By contention, each class in AliPhysics, AliRoot, and ROOT, is stored in an independent file, which has the same name as the class it defines (so later on, we will see that your analysis class, stored in a file 'AliAnalysisTaskMyTask', is called 'AliAnalysisTaskMyTask'). If you have never heard of classes (or C++), it might be a good idea to go through the C++ manual, which you can find here
.... here the link to the c++ manual .... and covers everything there is to know about C++, from the basics to more advanced topics. 

Classes are extended structures which contain both *variables* and *functions*, which are called *methods* as members. Often, variables must be *accessed* through these methods. This might sound a bit abstract, but it becomes much more clear when you look at in a small code example:

```cpp
    class Rectangle
    {
     private:
      int width, height;
     public:
      Rectangle(int,int);
      int GetArea() {return height * width;}
    }
```
Here we defined a class, called *Rectangle*, which has variables *width* and *height*, and a *method* called `GetArea` which gives us access to (information related to) the members. 

Classes are nice and important, because they can be *derived* from one-another (a feature called *inheritance*. Look at the figure below 


![image](inheritance.png)

In this figure, CRectangle is *derived* from *base* class CPolyogon, an *inherits* its members. If we want to define a second class, CTriangle, which is also a polygon and will therefore have features in common with CRectangle, we can also derive it from base class CPolyogon. This  avoids having to **repeat** common code for multiple which share features. 

{% callout "Beware" %}
Classes are very powerful, but inheritance can sometimes make it tricky to understand how code is structured!
{% endcallout %}

Let's take a look at how our classes would look like when we put them down as C++ code. First, we define out base class, the polygon

```cpp
class Polygon
{
 private:
  int width, height;
}
```
This example lives in 2-dimensional space, so our polygon is fully defined by its width and its height. The two polygons that we want to define, are a rectangle and a triangle. The Rectangle can be defined as follows

```cpp
    class Rectangle : public Polygon
    {
     public:
      Rectangle(int,int);
      int GetArea() {return height * width;}
    }
```

Note that we **do not** have to define the members `height` and `width` here, as they are already defined in our base class! The only *method* that is specific to the rectangle, is the `GetArea` method. 

Our Triangle class can be written as

```cpp
    class Triangle : public Polygon
    {
     public:
      Triangle(int,int);
      int GetArea() {return (height * width)/2;}
    }
```
 
Again, `width` and `height` are defined in the base class `Polygon`, but also the Triangle class gets its own `GetArea` method. So now we have seen how **inheritance** makes our classes (and our life) simpler: by defining common functionality in a base class, we avoid *repetition* of code, which could easily lead to mistakes. 
# AliAnalysisTaskSE

Now that you are an expert at C++ classes, you might wonder why classes are relevant to writing an analysis task. In the AliPhysics analysis framework, all analysis tasks are derived from the same base class, called `AliAnalysisTaskSE`. 

{% callout "AliAnalysisTaskSE" %}
All the analysis tasks in AliPhysics are derived from the base class `AliAnalysisTaskSE`, where SE stands for 'single event'. This class in turn, is derived from the class `AliAnalysisTask` (if you are interested, you can go through the code and follow the full chain of inheritance). 
{% endcallout %}

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

## AliAnalysisTaskSE::UserCreateOutputObjects()

In this function, the user (i.e. the analyzer) can define the output objects of the analysis. These are e.g. histograms in which you store your physics results. These output objects can be attached to the output file(s) of the analysis. 

## AliAnalysisTaskSE::UserExec()

This function is called *for each, single event* over which your analysis task runs. This function is your 'event loop'. If the function `AliAnalysisTaskSE::SelectCollisionCandidates(UInt_t trigger_mask)` is called, it will only be executed for events which pass the trigger selection that you have specified. 

## AliAnalysisTaskSE::Terminate()

The `Terminate` function is called at the very end of the analysis, when all events in your input data have been analyzed. Often, you leave the `Terminate` function empty: usually it is more practical to write a small macro that performs post-processing on your analysis output files, rather than deferring this functionality to the `Terminate` function.   
