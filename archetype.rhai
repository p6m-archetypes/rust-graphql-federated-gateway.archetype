let context = #{};

if switch_enabled("debug-answers") || switch_enabled("debug-all") {
    display("Federated Gateway Answers:");
    display(as_yaml(ANSWERS));
}

context += render(Archetype("org-prompts"), ANSWERS);

context += set("project-name", "graphql-federated-gateway");

if switch_enabled("debug-context") || switch_enabled("debug-all") {
    display("Federated Gateway Context:");
    display(as_yaml(context));
}

render(Directory("contents"), context);

// Return context
context
