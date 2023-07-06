// Fork of Elttob's Fusion Instance defaultProps
// They made sense as is, so I'm not modifying them

type DefaultProps = Partial<{
    [K in keyof CreatableInstances]: Partial<{
        [P in keyof Instances[K]]: Instances[K][P]
    }>
}>;

export default DefaultProps;
