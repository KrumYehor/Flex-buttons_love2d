local mathAdd = {}
function mathAdd.rotate_point(px, py, cx, cy, angle)
    local radians = math.rad(angle)
    -- Переносим точку относительно центра
    local translated_x = px 
    local translated_y = py 
    -- Вычисляем новые координаты после вращения
    local rotated_x = translated_x * math.cos(radians) - translated_y * math.sin(radians)
    local rotated_y = translated_x * math.sin(radians) + translated_y * math.cos(radians)
    -- Возвращаем точку на место относительно центра
    return rotated_x + cx, rotated_y + cy
end
function mathAdd.rotate_polygon(points, cx, cy, angle)
    local rotated_points = {}

    -- Проходим по массиву точек, рассматривая их как пары (x, y)
    for i = 1, #points, 2 do
        local x, y = points[i], points[i + 1]
        local new_x, new_y = mathAdd.rotate_point(x, y, cx, cy, angle)

        -- Добавляем новые координаты в массив
        table.insert(rotated_points, new_x)
        table.insert(rotated_points, new_y)
    end

    return rotated_points
end
function mathAdd.line_lenght(p1, p2)
    return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end
function mathAdd.squared_distance(x1, y1, x2, y2)
    return (x1 - x2) ^ 2 + (y1 - y2) ^ 2
end

function mathAdd.pointInCircle(xm, ym, x, y, radius)
    j = xm - x
    k = ym - y
    j = j * j
    k = k * k

    if (math.sqrt(j + k) < radius) then
        return true
    else
        return false
    end
end

function mathAdd.triangleArea(x1, y1, x2, y2, x3, y3)
    return math.abs((x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2)
end

function mathAdd.DpointSegment(px, py, ax, ay, bx, by)
    -- Сначала вычисляем длину отрезка AB
    local ab_squared = mathAdd.squared_distance(ax, ay, bx, by)

    -- Если A и B совпадают, расстояние от точки P до A (или B)
    if ab_squared == 0 then
        return math.sqrt(mathAdd.squared_distance(px, py, ax, ay))
    end

    -- Вычисляем t, проекцию точки P на отрезок AB
    local t = ((px - ax) * (bx - ax) + (py - ay) * (by - ay)) / ab_squared

    -- Проверяем, лежит ли проекция внутри отрезка
    if t < 0 then
        -- Проекция находится за пределами A, используем A
        return math.sqrt(mathAdd.squared_distance(px, py, ax, ay))
    elseif t > 1 then
        -- Проекция находится за пределами B, используем B
        return math.sqrt(mathAdd.squared_distance(px, py, bx, by))
    end

    -- Если проекция находится на отрезке, вычисляем перпендикулярное расстояние
    local nearest_x = ax + t * (bx - ax)
    local nearest_y = ay + t * (by - ay)

    return math.sqrt(mathAdd.squared_distance(px, py, nearest_x, nearest_y))
end

function mathAdd.inPolygonBorder(xm, ym, x, y, triangles,distance_origin)

    pm = {
        x = xm,
        y = ym
    }
    for i = 2, #triangles, 2 do
        local p1 = {}
        local p2 = {}
        p1X = triangles[i - 1] + x
        p1Y = triangles[i] + y

        if (triangles[i + 2]) then
            p2X = triangles[i + 1] + x
            p2Y = triangles[i + 2] + y
        else
            p2X = triangles[1] + x
            p2Y = triangles[2] + y
        end

        local distance = mathAdd.DpointSegment(pm.x, pm.y, p1X, p1Y, p2X, p2Y)

        if distance < distance_origin then
            return true
        end
    end
    return false
end

function mathAdd.pointInTriangle(px, py, v)
    ax = v[1]
    ay = v[2]
    bx = v[3]
    by = v[4]
    cx = v[5]
    cy = v[6]
    -- Площадь треугольника ABC
    local areaABC = mathAdd.triangleArea(ax, ay, bx, by, cx, cy)
    -- Площади треугольников PAB, PBC, PCA
    local areaPAB = mathAdd.triangleArea(px, py, ax, ay, bx, by)
    local areaPBC = mathAdd.triangleArea(px, py, bx, by, cx, cy)
    local areaPCA = mathAdd.triangleArea(px, py, cx, cy, ax, ay)
    -- Проверка: сумма площадей треугольников PAB, PBC, PCA должна быть равна площади ABC
    return math.abs(areaPAB + areaPBC + areaPCA - areaABC) < 1e-6
end

return mathAdd
