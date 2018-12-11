//
//  PathTests.swift
//  GeometryScriptTests
//
//  Created by Nick Lockwood on 19/09/2018.
//  Copyright © 2018 Nick Lockwood. All rights reserved.
//

@testable import Euclid
import XCTest

class PathTests: XCTestCase {
    // MARK: isSimple

    func testSimpleLine() {
        let path = Path([
            .point(0, 1),
            .point(0, -1),
        ])
        XCTAssertTrue(path.isSimple)
        XCTAssertFalse(path.isClosed)
    }

    func testSimpleOpenTriangle() {
        let path = Path([
            .point(0, 1),
            .point(0, -1),
            .point(1, -1),
        ])
        XCTAssertTrue(path.isSimple)
        XCTAssertFalse(path.isClosed)
    }

    func testSimpleClosedTriangle() {
        let path = Path([
            .point(0, 1),
            .point(-1, -1),
            .point(1, -1),
            .point(0, 1),
        ])
        XCTAssertTrue(path.isSimple)
        XCTAssertTrue(path.isClosed)
    }

    func testSimpleOpenQuad() {
        let path = Path([
            .point(-1, 1),
            .point(-1, -1),
            .point(1, -1),
            .point(1, 1),
        ])
        XCTAssertTrue(path.isSimple)
        XCTAssertFalse(path.isClosed)
    }

    func testOverlappingOpenQuad() {
        let path = Path([
            .point(-1, 1),
            .point(1, -1),
            .point(-1, -1),
            .point(1, 1),
        ])
        XCTAssertFalse(path.isSimple)
        XCTAssertFalse(path.isClosed)
    }

    func testSimpleClosedQuad() {
        let path = Path([
            .point(-1, 1),
            .point(-1, -1),
            .point(1, -1),
            .point(1, 1),
            .point(-1, 1),
        ])
        XCTAssertTrue(path.isSimple)
        XCTAssertTrue(path.isClosed)
    }

    func testOverlappingClosedQuad() {
        let path = Path([
            .point(-1, 1),
            .point(1, -1),
            .point(-1, -1),
            .point(1, 1),
            .point(-1, 1),
        ])
        XCTAssertFalse(path.isSimple)
        XCTAssertTrue(path.isClosed)
    }

    // MARK: winding direction

    func testConvexClosedPathAnticlockwiseWinding() {
        let path = Path([
            .point(-1, 1),
            .point(-1, -1),
            .point(1, -1),
            .point(1, 1),
            .point(-1, 1),
        ])
        XCTAssertTrue(path.isClosed)
        XCTAssert(path.plane!.normal.z > 0)
    }

    func testConvexClosedPathClockwiseWinding() {
        let path = Path([
            .point(-1, -1),
            .point(-1, 1),
            .point(1, 1),
            .point(1, -1),
            .point(-1, -1),
        ])
        XCTAssertTrue(path.isClosed)
        XCTAssert(path.plane!.normal.z < 0)
    }

    func testConvexOpenPathAnticlockwiseWinding() {
        let path = Path([
            .point(-1, 1),
            .point(-1, -1),
            .point(1, -1),
        ])
        XCTAssertFalse(path.isClosed)
        XCTAssert(path.plane!.normal.z > 0)
    }

    func testConvexOpenPathClockwiseWinding() {
        let path = Path([
            .point(-1, -1),
            .point(-1, 1),
            .point(1, 1),
        ])
        XCTAssertFalse(path.isClosed)
        XCTAssert(path.plane!.normal.z < 0)
    }

    func testConcaveClosedPathAnticlockwiseWinding() {
        let path = Path([
            .point(-1, 0),
            .point(0, 0),
            .point(0, -1),
            .point(1, -1),
            .point(1, 1),
            .point(-1, 1),
            .point(-1, 0),
        ])
        XCTAssertTrue(path.isClosed)
        XCTAssert(path.plane!.normal.z > 0)
    }

    func testConcaveClosedPathClockwiseWinding() {
        let path = Path([
            .point(-1, 0),
            .point(0, 0),
            .point(0, 1),
            .point(1, 1),
            .point(1, -1),
            .point(-1, -1),
            .point(-1, 0),
        ])
        XCTAssertTrue(path.isClosed)
        XCTAssert(path.plane!.normal.z < 0)
    }

    func testConcaveOpenPathAnticlockwiseWinding() {
        let path = Path([
            .point(-1, 0),
            .point(0, 0),
            .point(0, -1),
            .point(1, -1),
            .point(-1, 1),
        ])
        XCTAssertFalse(path.isClosed)
        XCTAssert(path.plane!.normal.z > 0)
    }

    func testConcaveOpenPathClockwiseWinding() {
        let path = Path([
            .point(-1, 0),
            .point(0, 0),
            .point(0, 1),
            .point(1, 1),
            .point(-1, -1),
        ])
        XCTAssertFalse(path.isClosed)
        XCTAssert(path.plane!.normal.z < 0)
    }

    func testStraightLinePathAnticlockwiseWinding() {
        let path = Path([
            .point(-1, 1),
            .point(-1, -1),
        ])
        XCTAssertFalse(path.isClosed)
        XCTAssert(path.plane!.normal.z > 0)
    }

    func testStraightLinePathAnticlockwiseWinding2() {
        let path = Path([
            .point(-1, -1),
            .point(-1, 1),
        ])
        XCTAssertFalse(path.isClosed)
        XCTAssert(path.plane!.normal.z > 0)
    }

    func testStraightLinePathAnticlockwiseWinding3() {
        let path = Path([
            .point(1, 1),
            .point(1, -1),
        ])
        XCTAssertFalse(path.isClosed)
        XCTAssert(path.plane!.normal.z > 0)
    }

    // MARK: faceVertices

    func testFaceVerticesForConcaveClockwisePath() {
        let path = Path([
            .point(0, 1),
            .point(1, 0),
            .point(0, -1),
            .point(0.5, 0),
            .point(0, 1),
        ])
        guard let vertices = path.faceVertices else {
            XCTFail()
            return
        }
        XCTAssertEqual(vertices.count, 4)
    }

    func testFaceVerticesForDegenerateClosedAnticlockwisePath() {
        let path = Path([
            .point(0, 1),
            .point(0, 0),
            .point(0, -1),
            .point(0, 1),
        ])
        XCTAssert(path.isClosed)
        XCTAssertNil(path.faceVertices)
    }

    // MARK: edgeVertices

    func testEdgeVerticesForSmoothedClosedRect() {
        let path = Path([
            .curve(-1, 1),
            .curve(-1, -1),
            .curve(1, -1),
            .curve(1, 1),
            .curve(-1, 1),
        ])
        let vertices = path.edgeVertices
        XCTAssertEqual(vertices.count, 8)
        guard vertices.count >= 8 else { return }
        // positions
        XCTAssertEqual(vertices[0].position, Vector(-1, 1))
        XCTAssertEqual(vertices[1].position, Vector(-1, -1))
        XCTAssertEqual(vertices[2].position, Vector(-1, -1))
        XCTAssertEqual(vertices[3].position, Vector(1, -1))
        XCTAssertEqual(vertices[4].position, Vector(1, -1))
        XCTAssertEqual(vertices[5].position, Vector(1, 1))
        XCTAssertEqual(vertices[6].position, Vector(1, 1))
        XCTAssertEqual(vertices[7].position, Vector(-1, 1))
        // texture coords
        XCTAssertEqual(vertices[0].texcoord, Vector(0, 0))
        XCTAssertEqual(vertices[1].texcoord, Vector(0, 0.25))
        XCTAssertEqual(vertices[2].texcoord, Vector(0, 0.25))
        XCTAssertEqual(vertices[3].texcoord, Vector(0, 0.5))
        XCTAssertEqual(vertices[4].texcoord, Vector(0, 0.5))
        XCTAssertEqual(vertices[5].texcoord, Vector(0, 0.75))
        XCTAssertEqual(vertices[6].texcoord, Vector(0, 0.75))
        XCTAssertEqual(vertices[7].texcoord, Vector(0, 1))
        // normals
        XCTAssertEqual(vertices[0].normal.quantized(), Vector(-1, 1).normalized().quantized())
        XCTAssertEqual(vertices[1].normal.quantized(), Vector(-1, -1).normalized().quantized())
        XCTAssertEqual(vertices[2].normal.quantized(), Vector(-1, -1).normalized().quantized())
        XCTAssertEqual(vertices[3].normal.quantized(), Vector(1, -1).normalized().quantized())
        XCTAssertEqual(vertices[4].normal.quantized(), Vector(1, -1).normalized().quantized())
        XCTAssertEqual(vertices[5].normal.quantized(), Vector(1, 1).normalized().quantized())
        XCTAssertEqual(vertices[6].normal.quantized(), Vector(1, 1).normalized().quantized())
        XCTAssertEqual(vertices[7].normal.quantized(), Vector(-1, 1).normalized().quantized())
    }

    func testEdgeVerticesForSmoothedCylinder() {
        let path = Path([
            .point(0, 1),
            .curve(-1, 1),
            .curve(-1, -1),
            .point(0, -1),
        ])
        let vertices = path.edgeVertices
        XCTAssertEqual(vertices.count, 6)
        guard vertices.count >= 6 else { return }
        // positions
        XCTAssertEqual(vertices[0].position, Vector(0, 1))
        XCTAssertEqual(vertices[1].position, Vector(-1, 1))
        XCTAssertEqual(vertices[2].position, Vector(-1, 1))
        XCTAssertEqual(vertices[3].position, Vector(-1, -1))
        XCTAssertEqual(vertices[4].position, Vector(-1, -1))
        XCTAssertEqual(vertices[5].position, Vector(0, -1))
        // texture coords
        XCTAssertEqual(vertices[0].texcoord, Vector(0, 0))
        XCTAssertEqual(vertices[1].texcoord, Vector(0, 0.25))
        XCTAssertEqual(vertices[2].texcoord, Vector(0, 0.25))
        XCTAssertEqual(vertices[3].texcoord, Vector(0, 0.75))
        XCTAssertEqual(vertices[4].texcoord, Vector(0, 0.75))
        XCTAssertEqual(vertices[5].texcoord, Vector(0, 1))
        // normals
        XCTAssertEqual(vertices[0].normal, Vector(0, 1))
        XCTAssertEqual(vertices[1].normal.quantized(), Vector(-1, 1).normalized().quantized())
        XCTAssertEqual(vertices[2].normal.quantized(), Vector(-1, 1).normalized().quantized())
        XCTAssertEqual(vertices[3].normal.quantized(), Vector(-1, -1).normalized().quantized())
        XCTAssertEqual(vertices[4].normal.quantized(), Vector(-1, -1).normalized().quantized())
        XCTAssertEqual(vertices[5].normal, Vector(0, -1))
    }

    func testEdgeVerticesForSharpEdgedCylinder() {
        let path = Path([
            .point(0, 1),
            .point(-1, 1),
            .point(-1, -1),
            .point(0, -1),
        ])
        let vertices = path.edgeVertices
        XCTAssertEqual(vertices.count, 6)
        guard vertices.count >= 6 else { return }
        // positions
        XCTAssertEqual(vertices[0].position, Vector(0, 1))
        XCTAssertEqual(vertices[1].position, Vector(-1, 1))
        XCTAssertEqual(vertices[2].position, Vector(-1, 1))
        XCTAssertEqual(vertices[3].position, Vector(-1, -1))
        XCTAssertEqual(vertices[4].position, Vector(-1, -1))
        XCTAssertEqual(vertices[5].position, Vector(0, -1))
        // texture coords
        XCTAssertEqual(vertices[0].texcoord, Vector(0, 0))
        XCTAssertEqual(vertices[1].texcoord, Vector(0, 0.25))
        XCTAssertEqual(vertices[2].texcoord, Vector(0, 0.25))
        XCTAssertEqual(vertices[3].texcoord, Vector(0, 0.75))
        XCTAssertEqual(vertices[4].texcoord, Vector(0, 0.75))
        XCTAssertEqual(vertices[5].texcoord, Vector(0, 1))
        // normals
        XCTAssertEqual(vertices[0].normal, Vector(0, 1))
        XCTAssertEqual(vertices[1].normal, Vector(0, 1))
        XCTAssertEqual(vertices[2].normal, Vector(-1, 0))
        XCTAssertEqual(vertices[3].normal, Vector(-1, 0))
        XCTAssertEqual(vertices[4].normal, Vector(0, -1))
        XCTAssertEqual(vertices[5].normal, Vector(0, -1))
    }

    func testEdgeVerticesForCircle() {
        let path = Path.circle(radius: 1, segments: 4)
        let vertices = path.edgeVertices
        XCTAssertEqual(vertices.count, 8)
        guard vertices.count >= 8 else { return }
        // positions
        XCTAssertEqual(vertices[0].position, Vector(0, 1))
        XCTAssertEqual(vertices[1].position, Vector(-1, 0))
        XCTAssertEqual(vertices[2].position, Vector(-1, 0))
        XCTAssertEqual(vertices[3].position, Vector(0, -1))
        XCTAssertEqual(vertices[4].position, Vector(0, -1))
        XCTAssertEqual(vertices[5].position, Vector(1, 0))
        XCTAssertEqual(vertices[6].position, Vector(1, 0))
        XCTAssertEqual(vertices[7].position, Vector(0, 1))
        // texture coords
        XCTAssertEqual(vertices[0].texcoord, Vector(0, 0))
        XCTAssertEqual(vertices[1].texcoord, Vector(0, 0.25))
        XCTAssertEqual(vertices[2].texcoord, Vector(0, 0.25))
        XCTAssertEqual(vertices[3].texcoord, Vector(0, 0.5))
        XCTAssertEqual(vertices[4].texcoord, Vector(0, 0.5))
        XCTAssertEqual(vertices[5].texcoord, Vector(0, 0.75))
        XCTAssertEqual(vertices[6].texcoord, Vector(0, 0.75))
        XCTAssertEqual(vertices[7].texcoord, Vector(0, 1))
        // normals
        XCTAssertEqual(vertices[0].normal, Vector(0, 1))
        XCTAssertEqual(vertices[1].normal, Vector(-1, 0))
        XCTAssertEqual(vertices[2].normal, Vector(-1, 0))
        XCTAssertEqual(vertices[3].normal, Vector(0, -1))
        XCTAssertEqual(vertices[4].normal, Vector(0, -1))
        XCTAssertEqual(vertices[5].normal, Vector(1, 0))
        XCTAssertEqual(vertices[6].normal, Vector(1, 0))
        XCTAssertEqual(vertices[7].normal, Vector(0, 1))
    }

    func testEdgeVerticesForSemicircle() {
        let path = Path([
            .curve(0, 1),
            .curve(-1, 0),
            .curve(0, -1),
        ])
        let vertices = path.edgeVertices
        XCTAssertEqual(vertices.count, 4)
        guard vertices.count >= 4 else { return }
        // positions
        XCTAssertEqual(vertices[0].position, Vector(0, 1))
        XCTAssertEqual(vertices[1].position, Vector(-1, 0))
        XCTAssertEqual(vertices[2].position, Vector(-1, 0))
        XCTAssertEqual(vertices[3].position, Vector(0, -1))
        // texture coords
        XCTAssertEqual(vertices[0].texcoord, Vector(0, 0))
        XCTAssertEqual(vertices[1].texcoord, Vector(0, 0.5))
        XCTAssertEqual(vertices[2].texcoord, Vector(0, 0.5))
        XCTAssertEqual(vertices[3].texcoord, Vector(0, 1))
        // normals
        XCTAssertEqual(vertices[0].normal, Vector(0, 1))
        XCTAssertEqual(vertices[1].normal, Vector(-1, 0))
        XCTAssertEqual(vertices[2].normal, Vector(-1, 0))
        XCTAssertEqual(vertices[3].normal, Vector(0, -1))
    }

    func testEdgeVerticesForVerticalPath() {
        let path = Path([
            .point(-1, 1),
            .point(-1, -1),
        ])
        let vertices = path.edgeVertices
        XCTAssertEqual(vertices.count, 2)
        guard vertices.count >= 2 else { return }
        // positions
        XCTAssertEqual(vertices[0].position, Vector(-1, 1))
        XCTAssertEqual(vertices[1].position, Vector(-1, -1))
        // texture coords
        XCTAssertEqual(vertices[0].texcoord, Vector(0, 0))
        XCTAssertEqual(vertices[1].texcoord, Vector(0, 1))
        // normals
        XCTAssertEqual(vertices[0].normal, Vector(-1, 0))
        XCTAssertEqual(vertices[1].normal, Vector(-1, 0))
    }

    // Y-axis clipping

    func testClipClosedClockwiseTriangleToRightOfAxis() {
        let path = Path([
            .point(0, 0),
            .point(1, 1),
            .point(1, 0),
            .point(0, 0),
        ])
        let result = path.clippedToYAxis()
        XCTAssertEqual(result.points, [
            .point(0, 0),
            .point(-1, 1),
            .point(-1, 0),
            .point(0, 0),
        ])
    }

    func testClipClosedClockwiseTriangleMostlyRightOfAxis() {
        let path = Path([
            .point(-1, 0),
            .point(1, 1),
            .point(1, 0),
            .point(-1, 0),
        ])
        let result = path.clippedToYAxis()
        XCTAssertEqual(result.points, [
            .point(0, 0.5),
            .point(-1, 1),
            .point(-1, 0),
            .point(0, 0),
        ])
    }

    func testClipClosedRectangleSpanningAxis() {
        let path = Path([
            .point(-1, 1),
            .point(1, 1),
            .point(1, -1),
            .point(-1, -1),
            .point(-1, 1),
        ])
        let result = path.clippedToYAxis()
        XCTAssertEqual(result.points, [
            .point(-1, 1),
            .point(0, 1),
            .point(0, -1),
            .point(-1, -1),
            .point(-1, 1),
        ])
    }

    func testClosedAnticlockwiseTriangleLeftOfAxis() {
        let path = Path(unchecked: [
            .point(0, 1),
            .point(-1, -1),
            .point(0, -1),
        ])
        let result = path.clippedToYAxis()
        XCTAssertEqual(result.points, [
            .point(0, 1),
            .point(-1, -1),
            .point(0, -1),
        ])
    }
}
