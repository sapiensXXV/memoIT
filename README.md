# memoIT
<p>
<img src="https://img.shields.io/badge/Swift-5.2-orange?logo=swift">
<img src="https://img.shields.io/badge/Xcode-13.2.1-blue?logo=xcode">
<img src="https://img.shields.io/badge/iOS-15.2-black?logo=apple">
</p>

### 🗒 그때그때 기록해요

> 안드로이드에서 아이폰으로 넘어오면서 원래 사용하던대로 간단하게 메모 앱을 사용하려 
했었고, 이정도의 앱은 나혼자서 스스로 간단하게 만들어 사용할 수 있으리라 생각했다. 그동안
데이터를 파이어베이스를 통해서 받아오는 애플리케이션 말고도, Core Data를 활용해 로컬에서 데이터를
불러와 만들어보기도 좋을 것이라 생각하였다.

memoIT은 postIT에서 그 이름을 따왔습니다. 포스트잇이 생각날 때마다
바로 기록할 수 있는 것처럼 메모잇은 아이폰에서 생각난 점, 혹은 기억해두어야 할
것들을 앱을 통해서 바로 기록해 둘 수 있는 애플리케이션 입니다.

### 구현 기능
* 작성한 메모 목록을 볼 수 있게 한다.
* 메모 목록 왼쪽 상단의 버튼을 통해 **메모를 추가**할 수 있다.
* 메모의 목록을 눌러 **메모를 삭제하거나 수정**할 수 있다.

|✅ 메모 작성|✅ 메모 삭제|✅ 메모 수정|
|:---:|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/76734067/162631647-24e4cec7-ed36-404b-ba35-777ff3004fd7.gif">|<img src="https://user-images.githubusercontent.com/76734067/162631654-5ee4b11c-9b9b-4ffc-b9f9-3f082ffe2b58.gif">|<img src="https://user-images.githubusercontent.com/76734067/162631656-1e201097-cc14-49eb-a3be-11c3dd2ab3cb.gif">|

## 리팩토링
알림이 발생할때마다 새로운 알림을 만들고, 알림의 액션을 추가하는 반복적인 코드가 발생하여 알림을 생성하고 실행시켜주는
함수를 추가하였습니다.
```swift
func activateDefaultAlert(title: String, message: String, alertAction: UIAlertAction? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if let action = alertAction {
        alert.addAction(action)
    }
    self.present(alert, animated: true, completion: nil)
}
```

사용예시
```swift
activateDefaultAlert(title: "제목이 입력되지 않았습니다",
                     message: "제목을 입력해주세요",
                     alertAction: okButton)
```

## 🔨버그 수정
아무 메모도 입력하지 않고 `Save`버튼을 눌렀을 때, 메모 목록으로 돌아가면 메모가 존재하는 버그를 해결하였습니다.<br>
메모의 타이틀이나 내용이 비어있는지 확인하기 이전에 `Memo(context: self.context)`를 통해서 `Memo`데이터를 만들었고
데이터가 실제로 로컬에 저장되지 않았더라도, 생성된 데이터이기 때문에 fetch하는과정에서 해당데이터를 포함시킨것으로 보입니다.
**완전히 제목이나 내용이 비어있는 것을 확인된 후에 객체를 생성해서 버그를 수정하였습니다.**
```swift
@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    //원래는 이곳에 있었던 newMemo객체 생성을
    let okButton = UIAlertAction(title: "OK", style: .default)
    
    if memoTitleTextField.text == "" {
        activateDefaultAlert(title: "제목이 입력되지 않았습니다",
                                message: "제목을 입력해주세요",
                                alertAction: okButton)
    } else if memoBodyTextView.text == "" {
        activateDefaultAlert(title: "내용이 입력되지 않았습니다",
                                message: "내용을 입력해주세요",
                                alertAction: okButton)
    } else {
        //이곳으로 옮겼습니다.
        let newMemo = Memo(context: self.context)
        newMemo.title = memoTitleTextField.text
        newMemo.body = memoBodyTextView.text
        newMemo.date = Date()
        do {
            try! self.context.save()
            print("저장되었습니다~")
        } catch {
            print(error)
        }
        self.fetchMemo()
        navigationController?.popViewController(animated: true)
    }
}
```