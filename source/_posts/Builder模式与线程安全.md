title: Builder模式与线程安全
author: LQL
tags:
  - JAVA
  - Effective Java
categories:
  - JAVA
date: 2019-11-23 19:53:00
---
>**《Effective Java》之条目2：当构造参数过多时使用Builder模式**

#### 1. 为什么这样建议？
  * 构造参数太多，创建对象时需要记住各个构造参数的作用以及位置。除非看文档，否则极容易出错
  * 代码可读性差（阅读代码时无法立刻通过变量名了解各个构造参数的作用）
  
#### 2. 为什么不建议使用Java Bean？
  * ***构造方法***在多次调用中被分割，可能会导致JavaBean处于不一致的状态（线程不安全）
  ```java
  NutritionFacts cocaCola = new NutritionFacts();
  cocaCola.setServingSize(240);
  cocaCola.setServings(8);
  cocaCola.setCalories(100);
  cocaCola.setSodium(35);
  cocaCola.setCarbohydrate(27);
  ```
  * 无法构建***不可变对象(immutable)***
  ```java
  public class Person {
      // 因为用final修饰变量必须要初始化
      // 要么在定义时初始化，要么在构造函数中初始化
      // 一旦初始化完成即不可变，所以无法通过JavaBean setter方法初始化
      private final String id = null;
      private final String name = null;

      public String getId() {
          return id;
      }

      public String getName() {
          return name;
      }
  }
  ```
  
#### 3. 为什么建议使用Builder模式？
  * 代码可读高，易于构建对象
  * 不同于JavaBean模式，可构建***不可变对象(immutable)***
```java
public class Person {
      //  必需变量
      private final String id;
      private final String name;

      //  可选变量
      private String address;
      private String email;
      private String job;

      //  builder
      public static class Builder {
        //  与Person成员变量相同
        private final String id;
        private final String name;

        private String address;
        private String email;
        private String job;

        public Builder(String id, String name) {
            this.id = id;
            this.name = name;
        }

        public Builder address(String address) {
              this.address = address;
              return this;
          }

          public Builder email(String email) {
              this.email = email;
              return this;
          }

          public Builder job(String job) {
              this.job = job;
              return this;
          }

          public Person build() {
              return new Person(this);
          }
      }

      public Person(Builder builder) {
          this.id = builder.id;
          this.name = builder.name;
          this.address = builder.address;
          this.email = builder.email;
          this.job = builder.job;
      }

      public static void main(String[] args) {
          //  构建Person对象
          Person person = new Builder("id", "name")
                  .address("address")
                  .email("email")
                  .job("job")
                  .build();
      }
  }
  ```
  
#### 4. 还有其他解决方式吗？
  * 使用JavaBean模式，但是在所有构建方法未完成时，冻结对象（暂时无法使用该对象）
  ```java
  // 加锁
  NutritionFacts cocaCola = new NutritionFacts();
  cocaCola.setServingSize(240);
  cocaCola.setServings(8);
  cocaCola.setCalories(100);
  cocaCola.setSodium(35);
  cocaCola.setCarbohydrate(27);
  // 释放锁
  ```
  
#### 5. 总结
  * JavaBean确实能解决问题，但是又会引起了新的问题(线程不安全与无法构建不可变对象)
  * Builder模式解决了问题，且不会出现JavaBean那样的副作用
  * ***Builder模式缺点:***
    * 构建对象时，必须先构建Builder对象，有性能损耗
    * 比伸缩构造方法模式更冗长，因此只有在有足够的参数时才值得使用它，比如四个或更多