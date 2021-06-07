import Foundation

public extension Int {
    
    var roman: String? {
           if (self <= 0 || self > 3999) {
               return nil
           }
           var n = self
           var result = ""
           while n > 0 {
               switch n {
               case 1000..<4000:
                   result.append("M")
                   n-=1000
               case 900..<1000:
                   result.append("CM")
                   n-=900
               case 500..<900:
                   result.append("D")
                   n-=500
               case 400..<500:
                   result.append("CD")
                   n-=400
               case 100..<400:
                   result.append("C")
                   n-=100
               case 90..<100:
                   result.append("XC")
                   n-=90
               case 50..<90:
                   result.append("L")
                   n-=50
               case 40..<50:
                   result.append("XL")
                   n-=40
               case 10..<40:
                   result.append("X")
                   n-=10
               case 9..<10:
                   result.append("IX")
                   n-=9
               case 5..<9:
                   result.append("V")
                   n-=5
               case 4..<5:
                   result.append("IV")
                   n-=4
               case 1..<4:
                   result.append("I")
                   n-=1
               default:
                   return result
               }
           }
           return result
       }
}
