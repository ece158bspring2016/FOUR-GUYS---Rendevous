/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import MapKit

class DirectionsTableView: UITableView {
  
  var directionsArray: [(startingAddress: String, endingAddress: String, route: MKRoute)]!
  
  override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}

extension DirectionsTableView: UITableViewDelegate {
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 120
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.font = UIFont(name: "HoeflerText-Regular", size: 14)
    label.numberOfLines = 5
    setLabelBackgroundColor(label, section: section)
    label.text = "SEGMENT #\(section+1)\n\nStarting point: \(directionsArray[section].startingAddress)\n"
    return label
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

    let label = UILabel()
    label.font = UIFont(name: "HoeflerText-Regular", size: 14)
    label.numberOfLines = 8
    setLabelBackgroundColor(label, section: section)
    // 1 Get the current section's route.
    let route = directionsArray[section].route
    // 2 Format expectedTravelTime using formatted() from the NSTimeInterval extension. formatted() uses an NSDateComponentsFormatter to convert the NSTimeInterval into hours-minutes-seconds format.
    let time = route.expectedTravelTime.formatted()
    // 3 Format the distance using the miles method of the CLLocationDistance extension.
    let miles = route.distance.miles()
    //4 Set the cell's label to show the ending address, distance, and expected travel time.
    label.text = "Ending point: \(directionsArray[section].endingAddress)\n\nDistance: \(miles) miles\n\nExpected Travel Time: \(time)"
    return label
  }
  
  func setLabelBackgroundColor(label: UILabel, section: Int) {
    switch section {
    case 0:
      label.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.75)
    case 1:
      label.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.75)
    default:
      label.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.75)
    }
  }
}

extension DirectionsTableView: UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return directionsArray.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return directionsArray[section].route.steps.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("DirectionCell") as UITableViewCell!
    cell.textLabel?.numberOfLines = 4
    cell.textLabel?.font = UIFont(name: "HoeflerText-Regular", size: 12)
    cell.userInteractionEnabled = false
    // 1 Get the array of MKRouteSteps belonging to the MKRoute that corresponds to the current section.
    let steps = directionsArray[indexPath.section].route.steps
    // 2 From that steps array, access the MKRouteStep object at the index corresponding to the current row.
    let step = steps[indexPath.row]
    // 3 Get step's i   nstructions String.

    let instructions = step.instructions
    // 4 Get step's distance and convert it from meters to miles using miles() of the CLLocationDistance extension included in DirectionsTableView.swift.
    let distance = step.distance.miles()
    // 5 Set the cell's label to show the step's instructions and distance.
    cell.textLabel?.text = "\(indexPath.row+1). \(instructions) - \(distance) miles"
    
    return cell
  }
}

extension Float {
  func format(f: String) -> String {
    return NSString(format: "%\(f)f", self) as String
  }
}

extension CLLocationDistance {
  func miles() -> String {
    let miles = Float(self)/1609.344
    return miles.format(".2")
  }
}

extension NSTimeInterval {
  func formatted() -> String {
    let formatter = NSDateComponentsFormatter()
    formatter.unitsStyle = .Full
    formatter.allowedUnits = [NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
    
    return formatter.stringFromTimeInterval(self)!
  }
}
