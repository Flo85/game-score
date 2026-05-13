import { Preferences } from "@capacitor/preferences";
import { nanoid } from "nanoid";

export function useGameStorage(prefix: string) {
  const LIST_KEY = `${prefix}-list`;

  const deleteItem = async (id: string): Promise<void> => {
    const list = await getList();
    const newList = list.filter((x) => x !== id);

    await saveList(newList);
    await Preferences.remove({ key: `${prefix}-${id}` });
  };

  const getList = async (): Promise<Array<string>> => {
    const { value } = await Preferences.get({ key: LIST_KEY });
    return value ? JSON.parse(value) : [];
  };

  const saveList = async (list: Array<string>): Promise<void> => {
    await Preferences.set({
      key: LIST_KEY,
      value: JSON.stringify(list),
    });
  };

  const loadItem = async <T extends Record<string, any>>(
    id: string,
  ): Promise<T | null> => {
    const { value } = await Preferences.get({ key: `${prefix}-${id}` });
    return value ? JSON.parse(value) : null;
  };

  const saveItem = async <T extends Record<string, any>>(
    data: T,
    id?: string,
  ): Promise<string> => {
    const itemId = id ?? nanoid();
    const list = await getList();

    if (!list.includes(itemId)) {
      list.push(itemId);
      await saveList(list);
    }

    await Preferences.set({
      key: `${prefix}-${itemId}`,
      value: JSON.stringify({ ...data, id: itemId }),
    });

    return itemId;
  };

  return { deleteItem, getList, loadItem, saveItem };
}
