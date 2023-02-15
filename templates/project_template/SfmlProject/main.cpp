#include <SFML/Graphics.hpp>

int main()
{
    // Create window
    sf::RenderWindow window(sf::VideoMode(200, 200), "SFML works!");

    // Create circular shape and fill it
    sf::CircleShape shape(100.f);
    shape.setFillColor(sf::Color::Green);

    // Game loop
    while (window.isOpen())
    {
        // Handle events
        sf::Event event;
        while (window.pollEvent(event))
        {
            // Closing the window with the X button
	    switch (event.type)
	    {
		case sf::Event::Closed:
		    window.close();
		    break;
	    }
        }

        window.clear();      // Clear screen
        window.draw(shape);  // Draw shape to buffer
        window.display();    // Render buffered geometries
    }

    return 0;
}
