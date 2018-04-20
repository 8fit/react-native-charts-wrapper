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

open class BalloonMarker: MarkerView {
    open var color: UIColor?
    open var markerVerticalOffset: CGFloat?
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


    public init(color: UIColor, font: UIFont, textColor: UIColor, markerVerticalOffset: CGFloat) {
        super.init(frame: CGRect.zero);
        self.color = color
        self.font = font
        self.textColor = textColor
        self.markerVerticalOffset = markerVerticalOffset

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

        var rect = CGRect(origin: point, size: _size)

        // Not enough place to draw the marker above
        if point.y - _size.height - markerVerticalOffset < 0 {
            rect.origin.y += markerVerticalOffset

            if point.x - _size.width / 2.0 < 0 {
                drawTopLeftRect(context: context, rect: rect)
            } else if (chart != nil && point.x + width - _size.width / 2.0 > (chart?.bounds.width)!) {
                rect.origin.x -= _size.width
                drawTopRightRect(context: context, rect: rect)
            } else {
                rect.origin.x -= _size.width / 2.0
                drawTopCenterRect(context: context, rect: rect)
            }

            rect.origin.y += self.topInsets.top
            rect.size.height -= self.topInsets.top + self.topInsets.bottom

        } else { // Enough place to draw the marker above
            rect.origin.y -= markerVerticalOffset
            rect.origin.y -= _size.height

            if point.x - _size.width / 2.0 < 0 {
                drawLeftRect(context: context, rect: rect)
            } else if (chart != nil && point.x + width - _size.width / 2.0 > (chart?.bounds.width)!) {
                rect.origin.x -= _size.width
                drawRightRect(context: context, rect: rect)
            } else {
                rect.origin.x -= _size.width / 2.0
                drawCenterRect(context: context, rect: rect)
            }

            rect.origin.y += self.insets.top
            rect.size.height -= self.insets.top + self.insets.bottom

        }
        return rect
    }

    func drawCenterRect(context: CGContext, rect: CGRect) {

        // A                   B
        //  +-----------------+
        //  |                 |
        //  |                 |
        //  |     F    D      |
        //  +-----+    +------+
        // G       \  /        C
        //          \/
        //           E

        let A = CGPoint(x: rect.origin.x, y: rect.origin.y)
        let B = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y)
        let C = CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - arrowSize.height)
        let D = CGPoint(x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height)
        let E = CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y + rect.size.height)
        let F = CGPoint(x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height)
        let G = CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height - arrowSize.height)
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: A)
        context.addLine(to: B)
        // context.addArc(tangent1End: B, tangent2End:  CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + 2), radius:4)
        context.addLine(to: C)
        context.addLine(to: D)
        context.addLine(to: E)
        context.addLine(to: F)
        context.addLine(to: G)
        context.addLine(to: A)
        context.fillPath()

    }

    func drawLeftRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + arrowSize.width / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.fillPath()

    }

    func drawRightRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x  + rect.size.width - arrowSize.width / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height - arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.fillPath()

    }

    func drawTopCenterRect(context: CGContext, rect: CGRect) {

        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width / 2.0, y: rect.origin.y))
        context.fillPath()

    }

    func drawTopLeftRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + arrowSize.width / 2.0, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))
        context.fillPath()

    }

    func drawTopRightRect(context: CGContext, rect: CGRect) {
        context.setFillColor((color?.cgColor)!)
        context.beginPath()
        context.move(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height))
        context.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width - arrowSize.height / 2.0, y: rect.origin.y + arrowSize.height))
        context.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y))
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

