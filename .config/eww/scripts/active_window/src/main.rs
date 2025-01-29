use hyprland::event_listener::EventListener;

fn main() {
    let mut event_listener = EventListener::new();

    event_listener.add_active_window_changed_handler(move |x| {
        match x {
            Some(window) => println!("{}", window.title),
            None => println!("-")
        }
    });

    let _ = event_listener.start_listener();
}
