const process = require('process');

function parseTransitions(lines, keys) {
    const keyMap = {};
    keys.forEach(k => {
        keyMap[k.value] = k.key;
    });

    const transitions = { initial: [] };

    for (const line of lines) {
        const [path, write] = line.split(':');
        const states = path.split('-');
        
        states.reduce((acc, state, index) => {
            const nextState = states.slice(0, index + 1).join('');
            if (!transitions[acc]) {
                transitions[acc] = [];
            }

            if (!(state in keyMap)) {
                console.error(`Error: State '${state}' not found in keys.`);
                process.exit(1);
            }

            const transition = { read: state, to_state: nextState, write: '' };
            if (index === states.length - 1) {
                transition.write = write.trim();
            }

            transitions[acc].push(transition);
            return nextState;
        }, 'initial');
    }

    return { transitions };
}

const lines = [
    "A-A-B:Beautiful Rhythm",
    "A-A-B-4:Beautiful Rhythm ~ Laughing Bea Her Hua"
];

const keys = [
    { key: "A", value: "A" },
    { key: "B", value: "B" },
    { key: "4", value: "4" }
];

console.log(JSON.stringify(parseTransitions(lines, keys), null, 4));
