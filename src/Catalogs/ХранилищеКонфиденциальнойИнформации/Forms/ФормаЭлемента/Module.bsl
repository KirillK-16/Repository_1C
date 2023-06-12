#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Объект.Ссылка.Пустая() Тогда
		УстановитьПривилегированныйРежим(Истина);
		НЗ = РегистрыСведений.БезопасноеХранилище.СоздатьНаборЗаписей();
		НЗ.Отбор.ВладелецХранилища.Установить(Строка(Объект.Ссылка.УникальныйИдентификатор()));
		НЗ.Прочитать();
		КолВо = НЗ.Количество();
		УстановитьПривилегированныйРежим(Ложь);
		
		Если КолВо > 0 Тогда
			СтроковоеПредставлениеЗначения = ЭтотОбъект.УникальныйИдентификатор;
			СтроковоеПредставлениеЗначенияПовторно = СтроковоеПредставлениеЗначения;
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДекорацииСовпаденияСтрок(Элемент)
	Если СтроковоеПредставлениеЗначения = СтроковоеПредставлениеЗначенияПовторно Тогда
		Элементы.ДекорацияСовпадение.Картинка = БиблиотекаКартинок.СтатусОк;
	Иначе
		Элементы.ДекорацияСовпадение.Картинка = БиблиотекаКартинок.СтатусНеОк;
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура СтроковоеПредставлениеЗначенияПриИзменении(Элемент)
	ИзменилиЗначение = Истина;
	УстановитьДекорацииСовпаденияСтрок(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СтроковоеПредставлениеЗначенияПовторноПриИзменении(Элемент)
	УстановитьДекорацииСовпаденияСтрок(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	Если Не Объект.Ссылка.Пустая() Тогда
		Если Элементы.Изменить.Пометка И ИзменилиЗначение Тогда
			Оповещение = Новый ОписаниеОповещения("ОтветПриНажатииНаКнопкуИзменения", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, НСтр("ru='Сохранить измененное значение?'"), РежимДиалогаВопрос.ДаНетОтмена)
		Иначе
			ПриНажатииНаКнопкуИзменения();
		КонецЕсли;
	Иначе
		Оповещение = Новый ОписаниеОповещения("ОтветПриНеобходимостиЗаписи", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Для редактирования значения элемент должен быть записан. Записать?'"), РежимДиалогаВопрос.ДаНет)		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОтветПриНеобходимостиЗаписи(Ответ, Параметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Попытка
			Записать();
		Исключение
			ПоказатьПредупреждение(, НСтр("ru='Не удалось записать элемент конфиденциальных данных'"));
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить();
		КонецПопытки;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОтветПриНажатииНаКнопкуИзменения(Ответ, Параметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Попытка
			Записать();
		Исключение
			ПоказатьПредупреждение(, НСтр("ru='Не удалось записать элемент конфиденциальных данных'"));
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить();
		КонецПопытки;	
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		СтроковоеПредставлениеЗначения = ЭтотОбъект.УникальныйИдентификатор;
		СтроковоеПредставлениеЗначенияПовторно = СтроковоеПредставлениеЗначения;
		
		ИнициализироватьСостояниеНеизмененнойФормы();
	Иначе //отмена, закрытие диалога
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПриНажатииНаКнопкуИзменения()
	Элементы.Изменить.Пометка = Не Элементы.Изменить.Пометка;
	Элементы.СтроковоеПредставлениеЗначения.ТолькоПросмотр = Не Элементы.СтроковоеПредставлениеЗначения.ТолькоПросмотр;
	Элементы.СтроковоеПредставлениеЗначенияПовторно.ТолькоПросмотр = Не Элементы.СтроковоеПредставлениеЗначенияПовторно.ТолькоПросмотр;
	Элементы.Показать.Доступность = Не Элементы.Изменить.Пометка;
	Элементы.Показать.Пометка = Ложь;
	Элементы.СтроковоеПредставлениеЗначения.РежимПароля = Истина;
	Элементы.СтроковоеПредставлениеЗначенияПовторно.РежимПароля = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ИзменилиЗначение Тогда
		УстановитьПривилегированныйРежим(Истина);
		РегистрыСведений.БезопасноеХранилище.ЗаписатьДанные(Строка(Объект.Ссылка.УникальныйИдентификатор()), СтроковоеПредставлениеЗначения);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ИзменилиЗначение И СтроковоеПредставлениеЗначения <> СтроковоеПредставлениеЗначенияПовторно Тогда
		ПоказатьПредупреждение(, НСтр("ru='Не равны введенное значение и его подтверждение'"));
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Показать(Команда)
	Элементы.Показать.Пометка = Не Элементы.Показать.Пометка;
	Элементы.СтроковоеПредставлениеЗначения.РежимПароля = Не Элементы.СтроковоеПредставлениеЗначения.РежимПароля;
	Элементы.СтроковоеПредставлениеЗначенияПовторно.РежимПароля = Не Элементы.СтроковоеПредставлениеЗначенияПовторно.РежимПароля;
	
	ПоказатьРеальноеЗначение(Элементы.Показать.Пометка);
КонецПроцедуры

&НаСервере
Процедура ПоказатьРеальноеЗначение(Показать)
	Если Показать Тогда
		УстановитьПривилегированныйРежим(Истина);
		СтроковоеПредставлениеЗначения = РегистрыСведений.БезопасноеХранилище.ПолучитьДанные(Строка(Объект.Ссылка.УникальныйИдентификатор()));
		СтроковоеПредставлениеЗначенияПовторно = СтроковоеПредставлениеЗначения;
		УстановитьПривилегированныйРежим(Ложь);
	Иначе
		СтроковоеПредставлениеЗначения = ЭтотОбъект.УникальныйИдентификатор;
		СтроковоеПредставлениеЗначенияПовторно = СтроковоеПредставлениеЗначения;
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ИнициализироватьСостояниеНеизмененнойФормы();
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьСостояниеНеизмененнойФормы()
	Элементы.Изменить.Пометка = Ложь;
	Элементы.Показать.Пометка = Ложь;
	Элементы.Показать.Доступность = Истина; 
	
	Элементы.СтроковоеПредставлениеЗначения.ТолькоПросмотр = Истина;
	Элементы.СтроковоеПредставлениеЗначенияПовторно.ТолькоПросмотр = Истина;
	
	Элементы.СтроковоеПредставлениеЗначения.РежимПароля = Истина;
	Элементы.СтроковоеПредставлениеЗначенияПовторно.РежимПароля = Истина;
	
	Элементы.ДекорацияСовпадение.Картинка = БиблиотекаКартинок.СтатусОк;
	
	ИзменилиЗначение = Ложь;
КонецПроцедуры

#КонецОбласти