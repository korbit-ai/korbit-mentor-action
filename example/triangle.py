class Shape:
    def __init__(self, name):
        self.name = name

    def area(self):
        pass


class Triangle(Shape):
    def __init__(self, name, base, height):
        super().__init__(name)
        self.base = base
        self.height = height

    def area(self):
        return (self.base * self.height) / 2

    def perimeter(self):
        return self.base + self.height + self.hypotenuse
