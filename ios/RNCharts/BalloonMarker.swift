//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 19/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//  https://github.com/danielgindi/Charts/blob/1788e53f22eb3de79eb4f08574d8ea4b54b5e417/ChartsDemo/Classes/Components/BalloonMarker.swift
//  Edit: Added textColor

import UIKit
import Foundation
import CoreGraphics
import SwiftyJSON

open class BalloonMarker: MarkerView {
    open var color: UIColor?
    open var markerVerticalOffset: CGFloat?
    open var markerBorderRadius: CGFloat?
    open var arrowSize = CGSize(width: 15, height: 11)
    open var font: UIFont?
    open var textColor: UIColor?
    open var minimumSize = CGSize()


    fileprivate var insets = UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
    fileprivate var topInsets = UIEdgeInsetsMake(20.0, 8.0, 8.0, 8.0)

    fileprivate var labelns: NSString?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _size: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedStringKey: Any]()


    public init(color: UIColor, font: UIFont, textColor: UIColor, markerVerticalOffset: CGFloat, markerBorderRadius: CGFloat) {
        super.init(frame: CGRect.zero);
        self.color = color
        self.font = font
        self.textColor = textColor
        self.markerVerticalOffset = markerVerticalOffset
        self.markerBorderRadius = markerBorderRadius

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }


    func drawRect(context: CGContext, point: CGPoint) -> CGRect{

        let chart = super.chartView

        let width = _size.width

        let markerVerticalOffset = self.markerVerticalOffset ?? 0;
        let markerBorderRadius = self.markerBorderRadius ?? 0;

        var rect = CGRect(origin: point, size: _size)

        // Not enough place to draw the marker above
        if point.y - _size.height - markerVerticalOffset < 0 {
            rect.origin.y += markerVerticalOffset

            if point.x - _size.width / 2.0 < 0 {
                drawTopLeftRect(context: context, rect: rect, radius: markerBorderRadius)
            } else if (chart != nil && point.x + width - _size.width / 2.0 > (chart?.bounds.width)!) {
                rect.origin.x -= _size.width
                drawTopRightRect(context: context, rect: rect, radius: markerBorderRadius)
            } else {
                rect.origin.x -= _size.width / 2.0
                drawTopCenterRect(context: context, rect: rect, radius: markerBorderRadius)
            }

            rect.origin.y += self.topInsets.top
            rect.size.height -= self.topInsets.top + self.topInsets.bottom

        } else { // Enough place to draw the marker above
            rect.origin.y -= markerVerticalOffset
            rect.origin.y -= _size.height

            if point.x - _size.width / 2.0 < 0 {
                drawLeftRect(context: context, rect: rect, radius: markerBorderRadius)
            } else if (chart != nil && point.x + width - _size.width / 2.0 > (chart?.bounds.width)!) {
                rect.origin.x -= _size.width
                drawRightRect(context: context, rect: rect, radius: markerBorderRadius)
            } else {
                rect.origin.x -= _size.width / 2.0
                drawCenterRect(context: context, rect: rect, radius: markerBorderRadius)
            }

            rect.origin.y += self.insets.top
            rect.size.height -= self.insets.top + self.insets.bottom

        }
        return rect
    }

    func drawCenterRect(context: CGContext, rect: CGRect, radius: CGFloat) {
        let arrowWidth = arrowSize.width
        let arrowHeight = arrowSize.height
        let width = rect.size.width
        let height = rect.size.height - arrowHeight

        let xO = rect.origin.x
        let yO = rect.origin.y

        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: xO + radius, y: yO))
        context.addLine(to: CGPoint(x: xO + width - radius, y: yO))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO), tangent2End:  CGPoint(x: xO + width, y: yO + radius), radius: radius)
        context.addLine(to: CGPoint(x: xO + width, y: yO + height - radius))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO + height), tangent2End:  CGPoint(x: xO + width - radius, y: yO + height), radius: radius)
        context.addLine(to: CGPoint(x: xO + (width + arrowWidth) / 2.0, y: yO + height))
        context.addLine(to: CGPoint(x: xO + width / 2.0, y: yO + height + arrowHeight))
        context.addLine(to: CGPoint(x: xO + (width - arrowWidth) / 2.0, y: yO + height))
        context.addLine(to: CGPoint(x: xO + radius, y: yO + height))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO + height), tangent2End:  CGPoint(x: xO, y: yO + height - radius), radius: radius)
        context.addLine(to: CGPoint(x: xO, y: yO + radius))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO), tangent2End:  CGPoint(x: xO + radius, y: yO), radius: radius)
        context.fillPath()

    }

    func drawLeftRect(context: CGContext, rect: CGRect, radius: CGFloat) {
        let arrowWidth = arrowSize.width
        let arrowHeight = arrowSize.height
        let width = rect.size.width
        let height = rect.size.height - arrowHeight

        let xO = rect.origin.x
        let yO = rect.origin.y

        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: xO + radius, y: yO))
        context.addLine(to: CGPoint(x: xO + width - radius, y: yO))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO), tangent2End:  CGPoint(x: xO + width, y: yO + radius), radius: radius)
        context.addLine(to: CGPoint(x: xO + width, y: yO + height - radius))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO + height), tangent2End:  CGPoint(x: xO + width - radius, y: yO + height), radius: radius)
        context.addLine(to: CGPoint(x: xO + arrowSize.width / 2.0, y: yO + height))
        context.addLine(to: CGPoint(x: xO, y: yO + height + arrowHeight))
        context.addLine(to: CGPoint(x: xO, y: yO + radius))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO), tangent2End:  CGPoint(x: xO + radius, y: yO), radius: radius)
        context.fillPath()

    }

    func drawRightRect(context: CGContext, rect: CGRect, radius: CGFloat) {
        let arrowWidth = arrowSize.width
        let arrowHeight = arrowSize.height
        let width = rect.size.width
        let height = rect.size.height - arrowHeight

        let xO = rect.origin.x
        let yO = rect.origin.y

        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: xO + radius, y: yO))
        context.addLine(to: CGPoint(x: xO + width - radius, y: yO))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO), tangent2End:  CGPoint(x: xO + width, y: yO + radius), radius: radius)
        context.addLine(to: CGPoint(x: xO + width, y: yO + height + arrowHeight))
        context.addLine(to: CGPoint(x: xO  + width - arrowSize.width / 2.0, y: yO + height))
        context.addLine(to: CGPoint(x: xO + (width - arrowWidth) / 2.0, y: yO + height))
        context.addLine(to: CGPoint(x: xO + radius, y: yO + height))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO + height), tangent2End:  CGPoint(x: xO, y: yO + height - radius), radius: radius)
        context.addLine(to: CGPoint(x: xO, y: yO + radius))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO), tangent2End:  CGPoint(x: xO + radius, y: yO), radius: radius)
        context.fillPath()
    }

    func drawTopCenterRect(context: CGContext, rect: CGRect, radius: CGFloat) {
        let arrowWidth = arrowSize.width
        let arrowHeight = arrowSize.height
        let width = rect.size.width
        let height = rect.size.height - arrowHeight

        let xO = rect.origin.x
        let yO = rect.origin.y + arrowHeight


        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: xO + radius, y: yO))
        context.addLine(to: CGPoint(x: xO + (width - arrowSize.width) / 2.0, y: yO))
        context.addLine(to: CGPoint(x: xO + width / 2.0, y: yO - arrowHeight))
        context.addLine(to: CGPoint(x: xO + (width + arrowSize.width) / 2.0, y: yO))

        context.addLine(to: CGPoint(x: xO + width - radius, y: yO))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO), tangent2End:  CGPoint(x: xO + width, y: yO + radius), radius: radius)
        context.addLine(to: CGPoint(x: xO + width, y: yO + height - radius))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO + height), tangent2End:  CGPoint(x: xO + width - radius, y: yO + height), radius: radius)
        context.addLine(to: CGPoint(x: xO + radius, y: yO + height))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO + height), tangent2End:  CGPoint(x: xO, y: yO + height - radius), radius: radius)
        context.addLine(to: CGPoint(x: xO, y: yO + radius))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO), tangent2End:  CGPoint(x: xO + radius, y: yO), radius: radius)
        context.fillPath()

    }

    func drawTopLeftRect(context: CGContext, rect: CGRect, radius: CGFloat) {
        let arrowWidth = arrowSize.width
        let arrowHeight = arrowSize.height
        let width = rect.size.width
        let height = rect.size.height - arrowHeight

        let xO = rect.origin.x
        let yO = rect.origin.y + arrowHeight


        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: xO, y: yO - arrowHeight))
        context.addLine(to: CGPoint(x: xO + arrowSize.width / 2.0, y: yO))
        context.addLine(to: CGPoint(x: xO + width - radius, y: yO))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO), tangent2End:  CGPoint(x: xO + width, y: yO + radius), radius: radius)
        context.addLine(to: CGPoint(x: xO + width, y: yO + height - radius))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO + height), tangent2End:  CGPoint(x: xO + width - radius, y: yO + height), radius: radius)
        context.addLine(to: CGPoint(x: xO + radius, y: yO + height))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO + height), tangent2End:  CGPoint(x: xO, y: yO + height - radius), radius: radius)
        context.addLine(to: CGPoint(x: xO, y: yO - arrowHeight))
        context.fillPath()
    }

    func drawTopRightRect(context: CGContext, rect: CGRect, radius: CGFloat) {
        let arrowWidth = arrowSize.width
        let arrowHeight = arrowSize.height
        let width = rect.size.width
        let height = rect.size.height - arrowHeight

        let xO = rect.origin.x
        let yO = rect.origin.y + arrowHeight


        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: xO + radius, y: yO))
        context.addLine(to: CGPoint(x: xO + width - arrowWidth, y: yO))
        context.addLine(to: CGPoint(x: xO + width, y: yO - arrowHeight))
        context.addLine(to: CGPoint(x: xO + width, y: yO + height - radius))
        context.addArc(tangent1End: CGPoint(x: xO + width, y: yO + height), tangent2End:  CGPoint(x: xO + width - radius, y: yO + height), radius: radius)
        context.addLine(to: CGPoint(x: xO + radius, y: yO + height))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO + height), tangent2End:  CGPoint(x: xO, y: yO + height - radius), radius: radius)
        context.addLine(to: CGPoint(x: xO, y: yO + radius))
        context.addArc(tangent1End: CGPoint(x: xO, y: yO), tangent2End:  CGPoint(x: xO + radius, y: yO), radius: radius)
        context.fillPath()

    }



    open override func draw(context: CGContext, point: CGPoint) {
        if (labelns == nil || labelns?.length == 0) {
            return
        }

        context.saveGState()

        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 3, color: UIColor.black.withAlphaComponent(0.3).cgColor)
        let rect = drawRect(context: context, point: point)

        UIGraphicsPushContext(context)

        context.setShadow(offset: CGSize(width: 2, height: 4), blur: 2, color: nil)
        labelns?.draw(in: rect, withAttributes: _drawAttributes)

        UIGraphicsPopContext()

        context.restoreGState()
    }

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {

        var label : String;

        if let candleEntry = entry as? CandleChartDataEntry {

            label = candleEntry.close.description
        } else {
            label = entry.y.description
        }

        if let object = entry.data as? JSON {
            if object["marker"].exists() {
                label = object["marker"].stringValue;

                if highlight.stackIndex != -1 && object["marker"].array != nil {
                    label = object["marker"].arrayValue[highlight.stackIndex].stringValue
                }
            }
        }

        labelns = label as NSString

        _drawAttributes.removeAll()
        _drawAttributes[NSAttributedStringKey.font] = self.font
        _drawAttributes[NSAttributedStringKey.paragraphStyle] = _paragraphStyle
        _drawAttributes[NSAttributedStringKey.foregroundColor] = self.textColor

        _labelSize = labelns?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        _size.width = _labelSize.width + self.insets.left + self.insets.right
        _size.height = _labelSize.height + self.insets.top + self.insets.bottom
        _size.width = max(minimumSize.width, _size.width)
        _size.height = max(minimumSize.height, _size.height)

    }
}

