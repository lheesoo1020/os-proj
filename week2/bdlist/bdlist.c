#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/list.h>
#include <linux/module.h>
#include <linux/slab.h>

struct birthday {
  int day;
  int month;
  int year;
  struct list_head list;
};

static LIST_HEAD(birthday_list);

struct birthday *createBirthday(int day, int month, int year) {

  /* TODO: 생일을 위한 메모리를 할당하고, 인자들을 채워 생일을 완성하세요. */
	struct birthday *new_bd;
	new_bd = kmalloc(sizeof(struct birthday), GFP_KERNEL);
	new_bd -> day = day;
	new_bd -> month = month;
	new_bd -> year = year;

	return new_bd;
}

int simple_init(void) {
  printk("INSTALL MODULE: bdlist\n");

  /* TODO: 생일 목록을 하나씩 생성하는대로 연결리스트에 연결시키세요(노드 삽입). */
  /* TODO: 완성된 연결리스트를 탐색하는 커널 함수를 사용하여 출력하세요. */
  struct birthday *bd1 = createBirthday(1,1,2001);
  struct birthday *bd2 = createBirthday(2,2,2002);
  struct birthday *bd3 = createBirthday(3,3,2003);
  
  list_add_tail(&bd1 -> list, &birthday_list);
  list_add_tail(&bd2 -> list, &birthday_list);
  list_add_tail(&bd3 -> list, &birthday_list);

  struct birthday *pos;
  list_for_each_entry(pos, &birthday_list, list) {
	  printk(KERN_INFO "Day %d, %d, %d", pos -> day, pos -> month, pos -> year);
  }


  return 0;
}

void simple_exit(void) {
  /* 모듈을 제거할 때는 생성한 연결 리스트도 하나씩 제거하며 끝내도록 하세요. */
  /* 제거를 하기 전에 리스트가 "비어있을 경우""에 대한 예외처리를 하는게 좋겠죠? */
  if(list_empty(&birthday_list)) {
    printk("List is Empty\n");
    return;
  }


  struct list_head *pos;
  struct list_head *n;
  struct birthday *tmp;
  list_for_each_safe(pos, n, &birthday_list) {
	  tmp = list_entry(pos, struct birthday, list);
	  printk(KERN_INFO "Removing %d, %d, %d", tmp -> day, tmp -> month, tmp -> year);
	  list_del(pos);
	  kfree(tmp);
  }

  /* TODO: 이제 본격적으로 연결리스트를 탐색하면서 하나씩 제거하도록 하시면 됩니다. */
  printk("REMOVE MODULE: bdlist\n");
}

module_init(simple_init);
module_exit(simple_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("make a list of birthdays and print");
MODULE_AUTHOR("Lee HeeSoo_2020076108");
