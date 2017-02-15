//
//  NSBezierPath.swift
//  Soundy
//
//  Created by Sendy Halim on 2/15/17.
//  Copyright © 2017 Sendy Halim. All rights reserved.
//

import AppKit

extension NSBezierPath {
  var cgPath: CGPath {
    let path = CGMutablePath()
    var points = [CGPoint](repeating: .zero, count: 3)

    for i in (0 ..< self.elementCount) {
      let type = self.element(at: i, associatedPoints: &points)

      switch type {
      case .moveToBezierPathElement:
        path.move(to: CGPoint(
          x: points[0].x,
          y: points[0].y
        ))

      case .lineToBezierPathElement:
        path.addLine(to: CGPoint(
          x: points[0].x,
          y: points[0].y
        ))

      case .curveToBezierPathElement:
        path.addCurve(
          to: CGPoint(x: points[2].x, y: points[2].y),
          control1: CGPoint(x: points[0].x, y: points[0].y),
          control2: CGPoint(x: points[1].x, y: points[1].y)
        )

      case .closePathBezierPathElement:
        path.closeSubpath()
      }
    }

    return path
  }
}
