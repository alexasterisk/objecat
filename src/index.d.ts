export type ObjecatWritableProperties<T extends Instance> = Partial<
	| {
		  [K in keyof WritableInstanceProperties<T> as Uncapitalize<string & K>]: WritableInstanceProperties<T>[K];
	  }
	| {
		  __children?: Instance[] | Instance;
	  }
	| {
		  [K in InstanceEventNames<T> as `__event_${Uncapitalize<string & K>}__`]: T[K] extends RBXScriptSignal<infer C>
			  ? (...args: Parameters<C>) => void
			  : never;
	  }
>;

export const children: "__children";
export function event<K extends string>(eventName: K): `__event_${Uncapitalize<K>}__`;
export function create<T extends keyof CreatableInstances>(
	className: T,
	properties?: ObjecatWritableProperties<Instances[T]>
): Instances[T];

export default create;
