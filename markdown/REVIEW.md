# Code Review

## Project Structure

- [Clean Swift](https://hackernoon.com/introducing-clean-swift-architecture-vip-770a639ad7bf)
- [Viper Design Pattern](https://medium.com/@smalam119/viper-design-pattern-for-ios-application-development-7a9703902af6)

## Struct

- [init](https://medium.com/@sergueivinnitskii/easy-struct-initialization-in-swift-8ee46b8d84d5)
- [Codable](https://hackernoon.com/everything-about-codable-in-swift-4-97d0e18a2999)

## Tips

- You can add a Navigation Bar to the TabBar and add a TabBarViewController to that TabBar
- With the buttons in the TabBar you can process them in the TabBarViewController
```
    class TabBarLocationsViewController: UITabBarController {
        @IBAction func onClickRefreshButton(_ sender: Any) {
            onRefreshData()
        }
        
        @IBAction func onClickAddButton(_ sender: Any) {
        }
    }
```
