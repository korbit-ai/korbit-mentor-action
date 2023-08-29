class Shape:
    def __init__(self, name):
        self.name = name

    def area(self):
        pass


class Circle(Shape):
    def __init__(self, name, radius):
        super().__init__(name)
        self.radius = radius

    def area(self):
        return 3.14 * self.radius**2

    def circumference(self):
        return 2 * 3.14 * self.radius
