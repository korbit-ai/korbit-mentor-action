class Shape:
    def __init__(self, name):
        self.name = name

    def area(self):
        pass


class Rectangle(Shape):
    def __init__(self, name, width, height):
        super().__init__(name)
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.length

    def perimeter(self):
        return 2 * (self.width + self.height)
