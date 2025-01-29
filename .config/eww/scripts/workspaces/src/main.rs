use hyprland::event_listener::{EventListener, WorkspaceEventData, WorkspaceMovedEventData, NonSpecialWorkspaceEventData};

#[allow(dead_code)] #[derive(Debug)]
enum WorkspaceEvent {
    Added(WorkspaceEventData),
    Changed(WorkspaceEventData),
    Deleted(WorkspaceEventData),
    Moved(WorkspaceMovedEventData),
    NonSpecial(NonSpecialWorkspaceEventData),
}

fn main() {
    let mut event_listener = EventListener::new();

    event_listener.add_workspace_added_handler(|e| fetch_and_print(WorkspaceEvent::Added(e)));
    event_listener.add_workspace_changed_handler(|e| fetch_and_print(WorkspaceEvent::Changed(e)));
    event_listener.add_workspace_deleted_handler(|e| fetch_and_print(WorkspaceEvent::Deleted(e)));
    
    /* TODO: handle moved/renamed
    event_listener.add_workspace_moved_handler(|e| fetch_and_print(WorkspaceEvent::Moved(e)));
    event_listener.add_workspace_renamed_handler(|e| fetch_and_print(WorkspaceEvent::NonSpecial(e)));
    */

    let _ = event_listener.start_listener();
}

fn fetch_and_print(x: WorkspaceEvent) {
    dbg!(x);
}